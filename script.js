async function loadProducts() {
  const res = await fetch('api/produtos.php', { headers: { Accept: 'application/json' } });
  if (!res.ok) {
    throw new Error('Falha ao buscar produtos');
  }

  const payload = await res.json();
  if (!payload.ok || !Array.isArray(payload.data)) {
    throw new Error(payload.message || 'Resposta invalida da API de produtos');
  }

  return payload.data.map((p) => ({
    id: String(p.id),
    name: p.name || '',
    desc: p.desc || '',
    price: Number(p.price || 0),
    category: p.category || 'geral',
    image: p.image || '',
    isMarmita: !!p.isMarmita,
    marmitaConfig: p.marmitaConfig || null,
  }));
}

function saveCart(cart) {
  localStorage.setItem('carrinho', JSON.stringify(cart));
}

function loadCart() {
  try {
    return JSON.parse(localStorage.getItem('carrinho') || '[]');
  } catch (e) {
    return [];
  }
}

const produtosEl = document.getElementById('produtos');
const carrinhoEl = document.getElementById('carrinho');
const itensCarrinhoEl = document.getElementById('itensCarrinho');
const totalEl = document.getElementById('total');
const contadorEl = document.getElementById('contador');
const abrirCarrinhoBtn = document.getElementById('abrirCarrinho');
const fecharCarrinhoBtn = document.getElementById('fecharCarrinho');
const limparCarrinhoBtn = document.getElementById('limparCarrinho');
const finalizarBtn = document.getElementById('finalizar');

let produtos = [];
let carrinho = [];

async function renderProdutos() {
  if (!produtosEl) return;

  try {
    produtos = await loadProducts();
  } catch (err) {
    console.error(err);
    produtos = [];
  }

  produtosEl.innerHTML = '';

  const categorias = {};
  produtos.forEach((p) => {
    const categoria = p.category || 'geral';
    if (!categorias[categoria]) categorias[categoria] = [];
    categorias[categoria].push(p);
  });

  Object.keys(categorias).forEach((cat) => {
    const section = document.createElement('section');
    section.innerHTML = `<div class="section-title">${cat.charAt(0).toUpperCase() + cat.slice(1)}</div>
      <div class="cards"></div>`;

    const cards = section.querySelector('.cards');
    categorias[cat].forEach((prod) => {
      const card = document.createElement('div');
      card.className = 'card-item';
      card.innerHTML = `
        <div class="thumb" style="width:100%;height:180px;overflow:hidden;">
          <img src="${prod.image || 'https://via.placeholder.com/400x180'}" alt="${escapeHtml(prod.name)}" style="width:100%;height:100%;object-fit:cover;display:block;">
        </div>
        <div class="body">
          <h4>${escapeHtml(prod.name)}</h4>
          <p>${escapeHtml(prod.desc || '')}</p>
          <div class="price">${
            prod.isMarmita
              ? 'A partir de R$ ' + Number(prod.marmitaConfig?.precoP || 0).toFixed(2)
              : 'R$ ' + Number(prod.price || 0).toFixed(2)
          }</div>
          <div class="buy">
            <button class="btn primary" data-id="${prod.id}" data-marmita="${!!prod.isMarmita}">
              ${prod.isMarmita ? 'Montar Marmita' : 'Adicionar'}
            </button>
          </div>
        </div>
      `;
      cards.appendChild(card);
    });

    produtosEl.appendChild(section);
  });
}

if (produtosEl) {
  produtosEl.addEventListener('click', (e) => {
    const btn = e.target.closest('button[data-id]');
    if (!btn) return;

    const id = btn.getAttribute('data-id');
    const produto = produtos.find((p) => String(p.id) === String(id));
    if (!produto) return;

    if (produto.isMarmita) {
      window.location.href = `marmita.html?id=${produto.id}`;
      return;
    }

    addToCart({ ...produto, quantidade: 1 });
  });
}

function renderCarrinho() {
  carrinho = loadCart();
  if (!itensCarrinhoEl || !totalEl || !contadorEl) return;

  itensCarrinhoEl.innerHTML = '';
  let total = 0;

  carrinho.forEach((item, idx) => {
    const valor = item.isMarmita ? Number(item.valor ?? item.price ?? 0) : Number(item.price ?? 0);
    const desc = item.isMarmita
      ? `<div style="font-size:12px;color:#666">
          <b>Tam:</b> ${escapeHtml(item.tamanho || '-') }<br>
          <b>Carbo:</b> ${escapeHtml(item.carbo || '-') }<br>
          <b>Proteinas:</b> ${(item.proteinas || []).map(escapeHtml).join(', ') || '-'}<br>
          <b>Saladas:</b> ${(item.saladas || []).map(escapeHtml).join(', ') || '-'}<br>
          <b>Adicionais:</b> ${(item.adicionais || []).map(escapeHtml).join(', ') || '-'}
        </div>`
      : '';

    const itemHtml = document.createElement('div');
    itemHtml.className = 'cart-item';
    itemHtml.innerHTML = `
      <img src="${item.image || 'https://via.placeholder.com/60x60'}" alt="">
      <div style="flex:1">
        <div style="font-weight:600">${escapeHtml(item.name)}</div>
        ${desc}
        <div style="display:flex;align-items:center;gap:8px;margin-top:4px;">
          <button class="btn small" data-dec="${idx}" style="padding:2px 7px;">-</button>
          <span style="font-size:13px;color:#888;min-width:22px;text-align:center;">${item.quantidade}</span>
          <button class="btn small" data-inc="${idx}" style="padding:2px 7px;">+</button>
        </div>
      </div>
      <div style="font-weight:700">R$ ${(valor * item.quantidade).toFixed(2)}</div>
      <button class="btn small" data-remove="${idx}" style="margin-left:5px;">X</button>
    `;

    itensCarrinhoEl.appendChild(itemHtml);
    total += valor * item.quantidade;
  });

  totalEl.textContent = total.toFixed(2);
  contadorEl.textContent = String(carrinho.reduce((s, i) => s + i.quantidade, 0));
}

if (itensCarrinhoEl) {
  itensCarrinhoEl.addEventListener('click', (e) => {
    const btn = e.target.closest('[data-remove],[data-inc],[data-dec]');
    if (!btn) return;

    const idx = Number(btn.getAttribute('data-remove') ?? btn.getAttribute('data-inc') ?? btn.getAttribute('data-dec'));
    if (!Number.isInteger(idx)) return;

    if (!carrinho[idx]) return;

    if (btn.hasAttribute('data-remove')) {
      carrinho.splice(idx, 1);
    } else if (btn.hasAttribute('data-inc')) {
      carrinho[idx].quantidade = Math.max(1, Number(carrinho[idx].quantidade || 1) + 1);
    } else if (btn.hasAttribute('data-dec')) {
      const novaQtd = Number(carrinho[idx].quantidade || 1) - 1;
      if (novaQtd <= 0) {
        carrinho.splice(idx, 1);
      } else {
        carrinho[idx].quantidade = novaQtd;
      }
    }

    saveCart(carrinho);
    renderCarrinho();
  });
}

if (limparCarrinhoBtn) {
  limparCarrinhoBtn.onclick = () => {
    if (!confirm('Limpar carrinho?')) return;
    carrinho = [];
    saveCart(carrinho);
    renderCarrinho();
  };
}

if (finalizarBtn) {
  finalizarBtn.onclick = async () => {
    carrinho = loadCart();
    if (carrinho.length === 0) {
      alert('Carrinho vazio!');
      return;
    }

    window.location.href = 'finalizar_compra.php';
  };
}

if (abrirCarrinhoBtn) {
  abrirCarrinhoBtn.onclick = () => carrinhoEl && carrinhoEl.classList.add('open');
}

if (fecharCarrinhoBtn) {
  fecharCarrinhoBtn.onclick = () => carrinhoEl && carrinhoEl.classList.remove('open');
}

function addToCart(produto) {
  carrinho = loadCart();

  if (produto.isMarmita) {
    const idx = carrinho.findIndex((item) =>
      item.isMarmita &&
      item.id === produto.id &&
      item.tamanho === produto.tamanho &&
      item.carbo === produto.carbo &&
      JSON.stringify(item.proteinas || []) === JSON.stringify(produto.proteinas || []) &&
      JSON.stringify(item.saladas || []) === JSON.stringify(produto.saladas || []) &&
      JSON.stringify(item.adicionais || []) === JSON.stringify(produto.adicionais || [])
    );

    if (idx >= 0) {
      carrinho[idx].quantidade += produto.quantidade;
    } else {
      carrinho.push({ ...produto });
    }
  } else {
    const idx = carrinho.findIndex((item) => !item.isMarmita && item.id === produto.id);
    if (idx >= 0) {
      carrinho[idx].quantidade += produto.quantidade;
    } else {
      carrinho.push({ ...produto });
    }
  }

  saveCart(carrinho);
  renderCarrinho();
}

window.addEventListener('produtosAtualizados', async () => {
  await renderProdutos();
});

window.addEventListener('DOMContentLoaded', async () => {
  const params = new URLSearchParams(window.location.search);
  if (params.get('checkout') === 'ok') {
    alert('Pedido finalizado com sucesso!');
    params.delete('checkout');
    const qs = params.toString();
    const target = `${window.location.pathname}${qs ? `?${qs}` : ''}`;
    window.history.replaceState({}, '', target);
  }

  await renderProdutos();
  renderCarrinho();
});

function escapeHtml(s) {
  if (s == null) return '';
  return String(s)
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}
