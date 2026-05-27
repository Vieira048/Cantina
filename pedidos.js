const ordersListEl = document.getElementById('ordersList');
const ordersStatusEl = document.getElementById('ordersStatus');
const reportBarsEl = document.getElementById('reportBars');
const reportMonthEl = document.getElementById('reportMonth');

function currentMonthRef() {
  const now = new Date();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  return `${now.getFullYear()}-${month}`;
}

function brl(value) {
  return Number(value || 0).toLocaleString('pt-BR', { style: 'currency', currency: 'BRL' });
}

function escapeHtml(value) {
  return String(value ?? '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');
}

async function loadDashboard(monthRef) {
  const qs = new URLSearchParams({
    action: 'dashboard',
    month: monthRef,
  });

  const res = await fetch(`api/pedidos.php?${qs.toString()}`, {
    headers: { Accept: 'application/json' },
  });

  let payload = {};
  try {
    payload = await res.json();
  } catch (_err) {
    payload = {};
  }

  if (!res.ok || !payload.ok) {
    throw new Error(payload.message || 'Erro ao carregar pedidos e relatorio.');
  }

  return payload.data || {};
}

async function sendDelivered(orderId) {
  const res = await fetch('api/pedidos.php?action=deliver', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ pedido_id: orderId }),
  });

  let payload = {};
  try {
    payload = await res.json();
  } catch (_err) {
    payload = {};
  }

  if (!res.ok || !payload.ok) {
    throw new Error(payload.message || 'Erro ao atualizar status do pedido.');
  }
}

function normalizeItemText(item) {
  const name = String(item.nome || item.nome_produto || 'Item');
  const qty = Math.max(1, Number(item.quantidade || 1));
  const subtotal = Number(item.subtotal || (qty * Number(item.preco_unitario || 0)));
  return `${qty}x ${name} - ${brl(subtotal)}`;
}

function renderOrders(orders) {
  ordersListEl.innerHTML = '';

  if (!Array.isArray(orders) || orders.length === 0) {
    ordersStatusEl.textContent = 'Nenhum pedido aberto no momento.';
    ordersListEl.innerHTML = '<p class="empty-state">Sem pedidos pendentes.</p>';
    return;
  }

  ordersStatusEl.textContent = `${orders.length} pedido(s) em aberto.`;

  orders.forEach((order) => {
    const id = Number(order.id || 0);
    const clientName = String(order.usuario_nome || '').trim() || String(order.usuario_email || '').trim() || 'Usuario sem nome';
    const total = brl(order.valor_total || 0);
    const items = Array.isArray(order.itens) ? order.itens : [];

    const card = document.createElement('article');
    card.className = 'order-card';
    card.innerHTML = `
      <h3 class="order-title">Pedido #${id}</h3>
      <div class="order-meta">Cliente: ${escapeHtml(clientName)}</div>
      <div class="order-meta">Valor: ${escapeHtml(total)}</div>
      <h4 class="order-items-title">Itens</h4>
      <ul class="order-items">
        ${items.map((item) => `<li>${escapeHtml(normalizeItemText(item))}</li>`).join('')}
      </ul>
      <button type="button" class="btn-deliver" data-order-id="${id}">Entregue</button>
    `;

    if (items.length === 0) {
      const list = card.querySelector('.order-items');
      list.innerHTML = '<li>Lista de itens pedidos</li>';
    }

    ordersListEl.appendChild(card);
  });
}

function renderReport(report) {
  reportBarsEl.innerHTML = '';

  const items = Array.isArray(report?.items) ? report.items : [];
  if (items.length === 0) {
    reportBarsEl.innerHTML = '<p class="empty-state">Sem vendas finalizadas no mes selecionado.</p>';
    return;
  }

  const maxQty = items.reduce((max, item) => Math.max(max, Number(item.quantidade_vendida || 0)), 0) || 1;

  items.forEach((item) => {
    const product = String(item.produto || 'Produto');
    const qty = Number(item.quantidade_vendida || 0);
    const width = Math.max(6, Math.round((qty / maxQty) * 100));
    const faturamento = brl(item.faturamento || 0);

    const row = document.createElement('div');
    row.className = 'bar-row';
    row.innerHTML = `
      <div class="bar-label" title="${escapeHtml(product)}">${escapeHtml(product)}</div>
      <div class="bar-wrap" title="Faturamento: ${escapeHtml(faturamento)}">
        <div class="bar-fill" style="width:${width}%"></div>
      </div>
      <div class="bar-value">${qty}</div>
    `;
    reportBarsEl.appendChild(row);
  });
}

async function refreshDashboard() {
  const monthRef = (reportMonthEl.value || currentMonthRef()).trim();
  ordersStatusEl.textContent = 'Carregando pedidos...';
  reportBarsEl.innerHTML = '<p class="empty-state">Carregando relatorio...</p>';

  try {
    const data = await loadDashboard(monthRef);
    renderOrders(data.pedidos || []);
    renderReport(data.relatorio || { items: [] });
  } catch (err) {
    console.error(err);
    ordersStatusEl.textContent = err.message || 'Falha ao carregar dados.';
    ordersListEl.innerHTML = '<p class="empty-state">Erro ao listar pedidos.</p>';
    reportBarsEl.innerHTML = '<p class="empty-state">Erro ao carregar relatorio.</p>';
  }
}

document.addEventListener('click', async (event) => {
  const button = event.target.closest('.btn-deliver[data-order-id]');
  if (!button) return;

  const orderId = Number(button.dataset.orderId || 0);
  if (orderId <= 0) return;

  button.disabled = true;
  const oldText = button.textContent;
  button.textContent = 'Entregando...';

  try {
    await sendDelivered(orderId);
    await refreshDashboard();
  } catch (err) {
    console.error(err);
    alert(err.message || 'Nao foi possivel marcar o pedido como entregue.');
    button.disabled = false;
    button.textContent = oldText;
  }
});

if (reportMonthEl) {
  reportMonthEl.value = currentMonthRef();
  reportMonthEl.addEventListener('change', () => {
    refreshDashboard();
  });
}

refreshDashboard();
