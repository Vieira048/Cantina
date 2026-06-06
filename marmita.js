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

const urlParams = new URLSearchParams(window.location.search);
const marmitaId = urlParams.get('id');

const marmitaTamanho = document.getElementById('marmitaTamanho');
const marmitaOpcoes = document.getElementById('marmitaOpcoes');
const marmitaValor = document.getElementById('marmitaValor');
const formMarmita = document.getElementById('formMarmita');

let marmita = null;

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

function renderOpcoes() {
  const cfg = marmita.marmitaConfig || {};
  let html = '';

  html += `<div class="field"><label>Carboidrato</label>`;
  (cfg.carbos || []).forEach((c, i) => {
    html += `<label style="margin-right:10px;">
      <input type="radio" name="carbo" value="${escapeHtml(c)}" ${i === 0 ? 'checked' : ''}> ${escapeHtml(c)}
    </label>`;
  });
  html += `</div>`;

  html += `<div class="field"><label>Proteinas</label>`;
  (cfg.proteinas || []).forEach((p) => {
    html += `<label style="margin-right:10px;">
      <input type="checkbox" name="proteina" value="${escapeHtml(p)}"> ${escapeHtml(p)}
    </label>`;
  });
  html += `</div>`;

  html += `<div class="field"><label>Saladas</label>`;
  (cfg.saladas || []).forEach((s) => {
    html += `<label style="margin-right:10px;">
      <input type="checkbox" name="salada" value="${escapeHtml(s)}"> ${escapeHtml(s)}
    </label>`;
  });
  html += `</div>`;

  html += `<div class="field"><label>Adicionais</label>`;
  (cfg.adicionais || []).forEach((a) => {
    html += `<label style="margin-right:10px;">
      <input type="checkbox" name="adicional" value="${escapeHtml(a)}"> ${escapeHtml(a)}
    </label>`;
  });
  html += `</div>`;

  marmitaOpcoes.innerHTML = html;
}

function calcularValor(tamanho) {
  const cfg = marmita.marmitaConfig || {};
  if (tamanho === 'M') return Number(cfg.precoM || 0);
  if (tamanho === 'G') return Number(cfg.precoG || 0);
  return Number(cfg.precoP || 0);
}

function atualizarValor() {
  const valor = calcularValor(marmitaTamanho.value);
  marmitaValor.textContent = `Valor: ${formatMoney(valor)}`;
}

if (marmitaTamanho) {
  marmitaTamanho.addEventListener('change', atualizarValor);
}

if (formMarmita) {
  formMarmita.onsubmit = (e) => {
    e.preventDefault();

    const tamanho = marmitaTamanho.value;
    const valor = calcularValor(tamanho);

    const carbo = formMarmita.querySelector('input[name="carbo"]:checked')?.value || '';
    const proteinas = Array.from(formMarmita.querySelectorAll('input[name="proteina"]:checked')).map((i) => i.value);
    const saladas = Array.from(formMarmita.querySelectorAll('input[name="salada"]:checked')).map((i) => i.value);
    const adicionais = Array.from(formMarmita.querySelectorAll('input[name="adicional"]:checked')).map((i) => i.value);

    if (!carbo) {
      alert('Escolha um carboidrato!');
      return;
    }

    const carrinho = loadCart();
    carrinho.push({
      id: marmita.id,
      name: marmita.name,
      image: marmita.image,
      isMarmita: true,
      tamanho,
      valor,
      carbo,
      proteinas,
      saladas,
      adicionais,
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
    renderTamanhos();
    renderOpcoes();
    atualizarValor();
  } catch (err) {
    document.body.innerHTML = '<h2>Marmita nao encontrada.</h2>';
    console.error(err);
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
