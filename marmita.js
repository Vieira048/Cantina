function saveCart(cart) {
  localStorage.setItem('carrinho', JSON.stringify(cart));
}

function normalizeQty(item) {
  const raw = item?.quantidade ?? item?.qtd ?? item?.qty ?? item?.quantity ?? 1;
  const qty = Number(raw);
  if (!Number.isFinite(qty) || qty <= 0) {
    return 1;
  }
  return Math.max(1, Math.round(qty));
}

function normalizeCartItem(item) {
  if (!item || typeof item !== 'object') {
    return null;
  }

  const normalized = {
    ...item,
    quantidade: normalizeQty(item),
  };

  if (!normalized.name && normalized.nome) {
    normalized.name = String(normalized.nome);
  }

  return normalized;
}

function loadCart() {
  try {
    const raw = JSON.parse(localStorage.getItem('carrinho') || '[]');
    if (!Array.isArray(raw)) {
      return [];
    }
    return raw
      .map(normalizeCartItem)
      .filter((item) => item && item.quantidade > 0);
  } catch (e) {
    return [];
  }
}

async function loadMarmita(id) {
  const res = await fetch(`api/produtos.php?id=${encodeURIComponent(id)}`, {
    headers: { Accept: 'application/json' },
  });

  if (!res.ok) {
    throw new Error('Falha ao buscar dados da marmita');
  }

  const payload = await res.json();
  if (!payload.ok || !payload.data) {
    throw new Error(payload.message || 'Marmita nao encontrada');
  }

  if (!payload.data.isMarmita) {
    throw new Error('Produto informado nao e marmita');
  }

  return payload.data;
}

const CATEGORY_DEFS = [
  {
    key: 'carbo',
    legacyKey: 'carbos',
    inputName: 'cat_carbo',
    defaultName: 'Carboidrato',
    defaultIncluded: 1,
    defaultExtra: 3,
    required: true,
  },
  {
    key: 'proteinas',
    legacyKey: 'proteinas',
    inputName: 'cat_proteinas',
    defaultName: 'Proteinas',
    defaultIncluded: 1,
    defaultExtra: 5,
    required: true,
  },
  {
    key: 'saladas',
    legacyKey: 'saladas',
    inputName: 'cat_saladas',
    defaultName: 'Saladas',
    defaultIncluded: 1,
    defaultExtra: 2,
    required: true,
  },
  {
    key: 'adicionais',
    legacyKey: 'adicionais',
    inputName: 'cat_adicionais',
    defaultName: 'Adicionais',
    defaultIncluded: 0,
    defaultExtra: 4,
    required: false,
  },
];

const urlParams = new URLSearchParams(window.location.search);
const marmitaId = urlParams.get('id');

const marmitaTamanho = document.getElementById('marmitaTamanho');
const marmitaOpcoes = document.getElementById('marmitaOpcoes');
const marmitaValor = document.getElementById('marmitaValor');
const formMarmita = document.getElementById('formMarmita');
const marmitaFeedback = document.getElementById('marmitaFeedback');

let marmita = null;
let marmitaCategorias = [];

function formatMoney(value) {
  return `R$ ${Number(value || 0).toFixed(2).replace('.', ',')}`;
}

function renderTamanhos() {
  const cfg = marmita.marmitaConfig || {};
  marmitaTamanho.innerHTML = `
    <option value="P">Pequena - ${formatMoney(cfg.precoP || 0)}</option>
    <option value="M">Media - ${formatMoney(cfg.precoM || 0)}</option>
    <option value="G">Grande - ${formatMoney(cfg.precoG || 0)}</option>
  `;
}

function normalizeCategoryConfig(cfg, def) {
  const raw = cfg?.categorias?.[def.key] || {};
  const legacyItems = Array.isArray(cfg?.[def.legacyKey]) ? cfg[def.legacyKey] : [];
  const rawItems = Array.isArray(raw.itens) ? raw.itens : legacyItems;
  const inclusos = Number(raw.inclusos ?? raw.quantidadeInclusa ?? def.defaultIncluded);
  const valorExtra = Number(raw.valorExtra ?? raw.valorAdicional ?? def.defaultExtra);

  return {
    ...def,
    nome: String(raw.nome || def.defaultName),
    itens: rawItems.map(String).filter(Boolean),
    inclusos: Number.isFinite(inclusos) && inclusos >= 0 ? Math.round(inclusos) : def.defaultIncluded,
    valorExtra: Number.isFinite(valorExtra) && valorExtra >= 0 ? valorExtra : def.defaultExtra,
    obrigatoria: raw.obrigatoria ?? def.required,
  };
}

function loadCategoryConfig() {
  const cfg = marmita.marmitaConfig || {};
  marmitaCategorias = CATEGORY_DEFS.map((def) => normalizeCategoryConfig(cfg, def));
}

function renderOpcoes() {
  marmitaOpcoes.innerHTML = marmitaCategorias.map((category) => {
    const options = category.itens.length > 0
      ? category.itens.map((item, index) => `
          <label class="marmita-option">
            <input type="checkbox" name="${category.inputName}" value="${escapeHtml(item)}" ${category.key === 'carbo' && index === 0 ? 'checked' : ''}>
            <span>${escapeHtml(item)}</span>
          </label>
        `).join('')
      : '<p class="marmita-empty">Nenhum item cadastrado nesta categoria.</p>';

    return `
      <section class="marmita-category" data-category="${category.key}">
        <strong class="marmita-category-title">${escapeHtml(category.nome)}</strong>
        <div class="marmita-option-list">${options}</div>
      </section>
    `;
  }).join('');
}

function valorBasePorTamanho(tamanho) {
  const cfg = marmita.marmitaConfig || {};
  if (tamanho === 'M') return Number(cfg.precoM || 0);
  if (tamanho === 'G') return Number(cfg.precoG || 0);
  return Number(cfg.precoP || 0);
}

function selectedItemsFor(category) {
  return Array.from(formMarmita.querySelectorAll(`input[name="${category.inputName}"]:checked`))
    .map((input) => input.value);
}

function selectedItemsByCategory() {
  return marmitaCategorias.reduce((acc, category) => {
    acc[category.key] = selectedItemsFor(category);
    return acc;
  }, {});
}

function calculateExtraForCategory(category, selectedItems) {
  const extraQty = Math.max(0, selectedItems.length - category.inclusos);
  return extraQty * category.valorExtra;
}

function calcularResumo() {
  const tamanho = marmitaTamanho.value;
  const valorBase = valorBasePorTamanho(tamanho);
  const selecionados = selectedItemsByCategory();
  const extrasPorCategoria = {};
  let valorExtras = 0;

  marmitaCategorias.forEach((category) => {
    const extra = calculateExtraForCategory(category, selecionados[category.key] || []);
    extrasPorCategoria[category.key] = {
      nome: category.nome,
      quantidadeSelecionada: (selecionados[category.key] || []).length,
      quantidadeInclusa: category.inclusos,
      valorExtraPorItem: category.valorExtra,
      valorExtra: extra,
    };
    valorExtras += extra;
  });

  return {
    tamanho,
    valorBase,
    valorExtras,
    valorTotal: valorBase + valorExtras,
    selecionados,
    extrasPorCategoria,
  };
}

function atualizarValor() {
  const resumo = calcularResumo();
  marmitaValor.innerHTML = `
    <div class="marmita-summary">
      <div class="marmita-summary-line"><span>Tamanho</span><strong>${escapeHtml(resumo.tamanho || '-')}</strong></div>
      <div class="marmita-summary-line"><span>Valor base</span><strong>${formatMoney(resumo.valorBase)}</strong></div>
      <div class="marmita-summary-line"><span>Adicionais</span><strong>${formatMoney(resumo.valorExtras)}</strong></div>
      <div class="marmita-summary-line total"><span>Valor total</span><strong>${formatMoney(resumo.valorTotal)}</strong></div>
    </div>
  `;
}

function showFeedback(message) {
  if (!marmitaFeedback) {
    alert(message);
    return;
  }

  marmitaFeedback.textContent = message;
  marmitaFeedback.classList.add('show');
}

function clearFeedback() {
  if (!marmitaFeedback) return;
  marmitaFeedback.textContent = '';
  marmitaFeedback.classList.remove('show');
}

function validateRequiredCategories(resumo) {
  const missing = marmitaCategorias.find((category) =>
    category.obrigatoria &&
    category.itens.length > 0 &&
    (resumo.selecionados[category.key] || []).length === 0
  );

  if (!missing) {
    return true;
  }

  showFeedback(`Selecione pelo menos 1 ${missing.nome.toLowerCase()} para continuar.`);
  return false;
}

if (marmitaTamanho) {
  marmitaTamanho.addEventListener('change', atualizarValor);
}

if (marmitaOpcoes) {
  marmitaOpcoes.addEventListener('change', () => {
    clearFeedback();
    atualizarValor();
  });
}

if (formMarmita) {
  formMarmita.onsubmit = (e) => {
    e.preventDefault();
    clearFeedback();

    const resumo = calcularResumo();
    if (!validateRequiredCategories(resumo)) {
      return;
    }

    const carrinho = loadCart();
    carrinho.push({
      id: marmita.id,
      name: marmita.name,
      image: marmita.image,
      isMarmita: true,
      tamanho: resumo.tamanho,
      valorBase: resumo.valorBase,
      valorExtras: resumo.valorExtras,
      valor: resumo.valorTotal,
      price: resumo.valorTotal,
      carbo: resumo.selecionados.carbo?.[0] || '',
      carbos: resumo.selecionados.carbo || [],
      proteinas: resumo.selecionados.proteinas || [],
      saladas: resumo.selecionados.saladas || [],
      adicionais: resumo.selecionados.adicionais || [],
      categoriasEscolhidas: resumo.selecionados,
      extrasPorCategoria: resumo.extrasPorCategoria,
      quantidade: 1,
    });

    saveCart(carrinho);
    window.location.href = 'index.php';
  };
}

async function init() {
  if (!marmitaId) {
    document.body.innerHTML = '<h2>Marmita nao encontrada.</h2>';
    return;
  }

  try {
    marmita = await loadMarmita(marmitaId);
    loadCategoryConfig();
    renderTamanhos();
    renderOpcoes();
    atualizarValor();
  } catch (err) {
    document.body.innerHTML = '<h2>Marmita nao encontrada.</h2>';
  }
}

function escapeHtml(s) {
  if (s == null) return '';
  return String(s)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}

window.addEventListener('DOMContentLoaded', init);
