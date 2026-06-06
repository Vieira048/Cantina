async function apiListProducts() {
  const res = await fetch('api/produtos.php', { headers: { Accept: 'application/json' } });
  if (!res.ok) throw new Error('Falha ao carregar produtos');

  const payload = await res.json();
  if (!payload.ok || !Array.isArray(payload.data)) {
    throw new Error(payload.message || 'Resposta invalida da API');
  }

  return payload.data.map((p) => ({
    id: String(p.id),
    name: p.name || '',
    desc: p.desc || '',
    price: Number(p.price || 0),
    category: p.category || 'produtos',
    image: p.image || '',
    isMarmita: !!p.isMarmita,
    marmitaConfig: p.marmitaConfig || null,
  }));
}

function formatMoneyValue(value) {
  return Number(value || 0).toFixed(2).replace('.', ',');
}

async function apiSaveProduct(produto) {
  const res = await fetch('api/produtos.php', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(produto),
  });

  let payload = {};
  try {
    payload = await res.json();
  } catch (_err) {
    payload = {};
  }

  if (!res.ok || !payload.ok) {
    throw new Error(payload.message || 'Erro ao salvar produto');
  }

  return payload;
}

async function apiDeleteProduct(id) {
  const res = await fetch(`api/produtos.php?id=${encodeURIComponent(id)}`, {
    method: 'DELETE',
  });

  let payload = {};
  try {
    payload = await res.json();
  } catch (_err) {
    payload = {};
  }

  if (!res.ok || !payload.ok) {
    throw new Error(payload.message || 'Erro ao remover produto');
  }

  return payload;
}

const tabProdutos = document.getElementById('tabProdutos');
const tabMarmitas = document.getElementById('tabMarmitas');
const secProdutos = document.getElementById('secProdutos');
const secMarmitas = document.getElementById('secMarmitas');
const form = document.getElementById('formProduto');
const formMarmita = document.getElementById('formMarmita');
const listaProdutosEl = document.getElementById('listaProdutos');

let productsCache = [];
let marmitaCarbos = [];
let marmitaProteinas = [];
let marmitaSaladas = [];
let marmitaAdicionais = [];

tabProdutos.onclick = () => {
  secProdutos.style.display = '';
  secMarmitas.style.display = 'none';
  tabProdutos.classList.add('primary');
  tabProdutos.classList.remove('outline');
  tabMarmitas.classList.remove('primary');
  tabMarmitas.classList.add('outline');
};

tabMarmitas.onclick = () => {
  secProdutos.style.display = 'none';
  secMarmitas.style.display = '';
  tabMarmitas.classList.add('primary');
  tabMarmitas.classList.remove('outline');
  tabProdutos.classList.remove('primary');
  tabProdutos.classList.add('outline');
};

function renderMarmitaList(containerId, arr) {
  const el = document.getElementById(containerId);
  el.innerHTML = '';

  arr.forEach((v, i) => {
    const row = document.createElement('div');
    row.style.display = 'flex';
    row.style.justifyContent = 'space-between';
    row.style.marginBottom = '6px';
    row.innerHTML = `<span>${escapeHtml(v)}</span><div><button class="btn small" data-idx="${i}" data-list="${containerId}">Remover</button></div>`;
    el.appendChild(row);
  });
}

async function refreshProducts() {
  try {
    productsCache = await apiListProducts();
    renderListaProdutos();
    window.dispatchEvent(new Event('produtosAtualizados'));
  } catch (err) {
    console.error(err);
    alert(err.message || 'Erro ao carregar produtos');
    productsCache = [];
    renderListaProdutos();
  }
}

if (form) {
  form.addEventListener('submit', async (e) => {
    e.preventDefault();

    const id = document.getElementById('produtoId').value.trim();
    const name = document.getElementById('nome').value.trim() || 'Sem nome';
    const category = document.getElementById('categoria').value;
    const price = Number(document.getElementById('preco').value || 0);
    const desc = document.getElementById('descricao').value.trim();
    let image = document.getElementById('fotoUrl').value.trim();
    const file = document.getElementById('fotoFile').files[0];

    if (category === 'marmitas') {
      alert('Cadastre marmitas na aba Marmitas!');
      return;
    }

    if (file) {
      try {
        image = await fileToBase64(file);
      } catch (_err) {
        alert('Erro ao processar imagem. Tente novamente.');
        return;
      }
    }

    const produto = {
      id: id ? Number(id) : undefined,
      name,
      category,
      price,
      desc,
      image,
      isMarmita: false,
      marmitaConfig: null,
    };

    try {
      await apiSaveProduct(produto);
      resetForm();
      await refreshProducts();
      alert('Produto salvo com sucesso.');
    } catch (err) {
      console.error(err);
      alert(err.message || 'Erro ao salvar produto.');
    }
  });
}

if (formMarmita) {
  formMarmita.addEventListener('submit', async (e) => {
    e.preventDefault();

    const id = document.getElementById('marmitaId').value.trim();
    const name = document.getElementById('marmitaNome').value.trim() || 'Sem nome';
    const desc = document.getElementById('marmitaDesc').value.trim();
    let image = document.getElementById('marmitaFotoUrl').value.trim();
    const file = document.getElementById('marmitaFotoFile').files[0];

    if (file) {
      try {
        image = await fileToBase64(file);
      } catch (_err) {
        alert('Erro ao processar imagem. Tente novamente.');
        return;
      }
    }

    const precoP = Number(document.getElementById('marmitaPrecoP').value || 0);
    const precoM = Number(document.getElementById('marmitaPrecoM').value || 0);
    const precoG = Number(document.getElementById('marmitaPrecoG').value || 0);

    const produto = {
      id: id ? Number(id) : undefined,
      name,
      category: 'marmitas',
      price: precoP,
      desc,
      image,
      isMarmita: true,
      marmitaConfig: {
        precoP,
        precoM,
        precoG,
        carbos: marmitaCarbos.slice(),
        proteinas: marmitaProteinas.slice(),
        saladas: marmitaSaladas.slice(),
        adicionais: marmitaAdicionais.slice(),
      },
    };

    try {
      await apiSaveProduct(produto);
      resetFormMarmita();
      await refreshProducts();
      alert('Marmita salva com sucesso.');
    } catch (err) {
      console.error(err);
      alert(err.message || 'Erro ao salvar marmita.');
    }
  });
}

document.getElementById('marmitaAddCarbo').addEventListener('click', () => {
  const input = document.getElementById('marmitaNovoCarbo');
  const val = input.value.trim();
  if (!val) return;
  marmitaCarbos.push(val);
  input.value = '';
  renderMarmitaList('marmitaListaCarbos', marmitaCarbos);
});

document.getElementById('marmitaAddProteina').addEventListener('click', () => {
  const input = document.getElementById('marmitaNovoProteina');
  const val = input.value.trim();
  if (!val) return;
  marmitaProteinas.push(val);
  input.value = '';
  renderMarmitaList('marmitaListaProteinas', marmitaProteinas);
});

document.getElementById('marmitaAddSalada').addEventListener('click', () => {
  const input = document.getElementById('marmitaNovoSalada');
  const val = input.value.trim();
  if (!val) return;
  marmitaSaladas.push(val);
  input.value = '';
  renderMarmitaList('marmitaListaSaladas', marmitaSaladas);
});

document.getElementById('marmitaAddAdicional').addEventListener('click', () => {
  const input = document.getElementById('marmitaNovoAdicional');
  const val = input.value.trim();
  if (!val) return;
  marmitaAdicionais.push(val);
  input.value = '';
  renderMarmitaList('marmitaListaAdicionais', marmitaAdicionais);
});

document.addEventListener('click', async (e) => {
  const target = e.target;

  if (target.closest('#marmitaListaCarbos button')) {
    marmitaCarbos.splice(Number(target.dataset.idx), 1);
    renderMarmitaList('marmitaListaCarbos', marmitaCarbos);
  }

  if (target.closest('#marmitaListaProteinas button')) {
    marmitaProteinas.splice(Number(target.dataset.idx), 1);
    renderMarmitaList('marmitaListaProteinas', marmitaProteinas);
  }

  if (target.closest('#marmitaListaSaladas button')) {
    marmitaSaladas.splice(Number(target.dataset.idx), 1);
    renderMarmitaList('marmitaListaSaladas', marmitaSaladas);
  }

  if (target.closest('#marmitaListaAdicionais button')) {
    marmitaAdicionais.splice(Number(target.dataset.idx), 1);
    renderMarmitaList('marmitaListaAdicionais', marmitaAdicionais);
  }

  if (target.matches('#listaProdutos .edit')) {
    const id = target.dataset.id;
    carregarParaEdicao(id);
  }

  if (target.matches('#listaProdutos .remove')) {
    const id = target.dataset.id;
    if (!confirm('Remover produto?')) return;

    try {
      await apiDeleteProduct(id);
      await refreshProducts();
      alert('Produto removido com sucesso.');
    } catch (err) {
      console.error(err);
      alert(err.message || 'Erro ao remover produto.');
    }
  }
});

function resetForm() {
  form.reset();
  document.getElementById('produtoId').value = '';
}

function resetFormMarmita() {
  formMarmita.reset();
  document.getElementById('marmitaId').value = '';
  marmitaCarbos = [];
  marmitaProteinas = [];
  marmitaSaladas = [];
  marmitaAdicionais = [];
  renderMarmitaList('marmitaListaCarbos', marmitaCarbos);
  renderMarmitaList('marmitaListaProteinas', marmitaProteinas);
  renderMarmitaList('marmitaListaSaladas', marmitaSaladas);
  renderMarmitaList('marmitaListaAdicionais', marmitaAdicionais);
}

function renderListaProdutos() {
  listaProdutosEl.innerHTML = '';

  if (productsCache.length === 0) {
    listaProdutosEl.textContent = 'Nenhum produto cadastrado.';
    return;
  }

  productsCache.forEach((p) => {
    const line = document.createElement('div');
    line.className = 'produto-line';
    line.innerHTML = `
  <div style="display:flex;align-items:center;gap:10px">
    <img src="${p.image || 'https://via.placeholder.com/120x90'}" alt="${escapeHtml(p.name)}" style="max-width:80px;max-height:80px;object-fit:cover;border-radius:6px;" />
    <div>
      <div style="font-weight:700">${escapeHtml(p.name)}</div>
      <div style="font-size:13px;color:#666">${escapeHtml(p.category)} - R$ ${formatMoneyValue(p.price || 0)}</div>
    </div>
  </div>
  <div>
    <button class="btn small edit" data-id="${p.id}">Editar</button>
    <button class="btn small remove" data-id="${p.id}">Remover</button>
  </div>
`;
    listaProdutosEl.appendChild(line);
  });
}

function carregarParaEdicao(id) {
  const p = productsCache.find((x) => String(x.id) === String(id));
  if (!p) return;

  if (p.isMarmita) {
    tabMarmitas.click();
    document.getElementById('marmitaId').value = p.id;
    document.getElementById('marmitaNome').value = p.name;
    document.getElementById('marmitaDesc').value = p.desc || '';
    document.getElementById('marmitaFotoUrl').value = p.image || '';
    document.getElementById('marmitaFotoFile').value = '';
    document.getElementById('marmitaPrecoP').value = p.marmitaConfig?.precoP || '';
    document.getElementById('marmitaPrecoM').value = p.marmitaConfig?.precoM || '';
    document.getElementById('marmitaPrecoG').value = p.marmitaConfig?.precoG || '';
    marmitaCarbos = Array.isArray(p.marmitaConfig?.carbos) ? p.marmitaConfig.carbos.slice() : [];
    marmitaProteinas = Array.isArray(p.marmitaConfig?.proteinas) ? p.marmitaConfig.proteinas.slice() : [];
    marmitaSaladas = Array.isArray(p.marmitaConfig?.saladas) ? p.marmitaConfig.saladas.slice() : [];
    marmitaAdicionais = Array.isArray(p.marmitaConfig?.adicionais) ? p.marmitaConfig.adicionais.slice() : [];
    renderMarmitaList('marmitaListaCarbos', marmitaCarbos);
    renderMarmitaList('marmitaListaProteinas', marmitaProteinas);
    renderMarmitaList('marmitaListaSaladas', marmitaSaladas);
    renderMarmitaList('marmitaListaAdicionais', marmitaAdicionais);
  } else {
    tabProdutos.click();
    document.getElementById('produtoId').value = p.id;
    document.getElementById('nome').value = p.name;
    document.getElementById('categoria').value = p.category;
    document.getElementById('preco').value = p.price || 0;
    document.getElementById('descricao').value = p.desc || '';
    document.getElementById('fotoUrl').value = p.image || '';
    document.getElementById('fotoFile').value = '';
  }
}

function fileToBase64(file) {
  return new Promise((res, rej) => {
    const fr = new FileReader();
    fr.onload = () => res(fr.result);
    fr.onerror = rej;
    fr.readAsDataURL(file);
  });
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

document.getElementById('resetForm').addEventListener('click', (e) => {
  e.preventDefault();
  resetForm();
});

document.getElementById('resetFormMarmita').addEventListener('click', (e) => {
  e.preventDefault();
  resetFormMarmita();
});

tabProdutos.click();
refreshProducts();
