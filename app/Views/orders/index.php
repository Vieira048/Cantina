<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Pedidos e Relatorio de Vendas</title>
  <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Merriweather:wght@300;400;700;900&display=swap');

    :root {
      --bg: #8c6e54;
      --panel: #bfa288;
      --card: #8f7c68;
      --header: #402b1f;
      --text: #1e110b;
      --bar: #4b7be0;
    }

    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      min-height: 100vh;
      font-family: "Merriweather", serif;
      background: var(--bg);
      color: var(--text);
    }

    .topbar {
      position: sticky;
      top: 0;
      z-index: 20;
      height: 82px;
      background: var(--header);
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 3px 14px rgba(0, 0, 0, 0.35);
    }

    .btn-back {
      position: absolute;
      left: 14px;
      top: 50%;
      transform: translateY(-50%);
      background: #d9ccc5;
      color: #402b1f;
      text-decoration: none;
      border-radius: 10px;
      padding: 9px 14px;
      font-size: 0.85rem;
      font-weight: 700;
    }

    .topbar h1 {
      margin: 0;
      background: rgba(217, 204, 197, 0.18);
      border-radius: 999px;
      padding: 8px 22px;
      color: #000;
      font-weight: 900;
      font-size: 2.55rem;
      line-height: 1;
    }

    .layout {
      max-width: 1280px;
      margin: 18px auto 0;
      padding: 0 18px 22px;
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 30px;
      align-items: start;
    }

    .orders-shell,
    .report-shell {
      background: var(--panel);
      border-radius: 24px;
      padding: 26px 24px;
      min-height: calc(100vh - 140px);
    }

    .orders-list {
      display: flex;
      flex-direction: column;
      gap: 18px;
    }

    .order-card {
      background: var(--card);
      border-radius: 22px;
      padding: 18px;
      color: #000;
      box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.05);
    }

    .order-title {
      margin: 0;
      text-align: center;
      font-size: 2rem;
      line-height: 1.1;
      font-weight: 900;
    }

    .order-meta {
      margin-top: 8px;
      font-size: 0.9rem;
      line-height: 1.3;
    }

    .order-items-title {
      margin: 20px 0 8px;
      text-align: center;
      font-size: 2.25rem;
      font-weight: 900;
      line-height: 1;
    }

    .order-items {
      margin: 0 0 18px;
      padding-left: 22px;
      font-size: 1rem;
      line-height: 1.45;
    }

    .order-items li + li {
      margin-top: 5px;
    }

    .btn-deliver {
      display: block;
      width: 74%;
      margin: 0 auto;
      border-radius: 999px;
      border: 2px solid #f2e5dc;
      background: #4a2e20;
      color: #fff;
      font-family: inherit;
      font-weight: 700;
      font-size: 0.95rem;
      padding: 10px 16px;
      cursor: pointer;
    }

    .btn-deliver:disabled {
      cursor: wait;
      opacity: 0.6;
    }

    .report-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
      margin-bottom: 18px;
    }

    .report-title {
      margin: 0;
      font-size: 3rem;
      line-height: 1;
      font-weight: 900;
      color: #000;
    }

    #reportMonth {
      border: 1px solid #7d6453;
      background: #d9ccc5;
      border-radius: 9px;
      padding: 8px 10px;
      color: #2d1a12;
      font-family: inherit;
      font-weight: 700;
    }

    .report-bars {
      margin-top: 12px;
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .bar-row {
      display: grid;
      grid-template-columns: 110px 1fr 58px;
      align-items: center;
      gap: 10px;
      min-height: 28px;
      font-size: 0.92rem;
    }

    .bar-label {
      text-align: right;
      color: #25160f;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .bar-wrap {
      position: relative;
      height: 16px;
      border-radius: 999px;
      background: rgba(64, 43, 31, 0.14);
    }

    .bar-fill {
      height: 100%;
      border-radius: 999px;
      background: var(--bar);
    }

    .bar-value {
      font-size: 0.85rem;
      font-weight: 700;
      color: #25160f;
      text-align: right;
    }

    .empty-state {
      margin: 0;
      font-size: 1rem;
      opacity: 0.8;
      padding: 8px 0;
    }

    .status {
      margin: 0 0 10px;
      font-size: 0.9rem;
      font-weight: 700;
      color: #41281c;
    }

    @media (max-width: 1080px) {
      .layout {
        grid-template-columns: 1fr;
      }

      .orders-shell,
      .report-shell {
        min-height: auto;
      }

      .report-title {
        font-size: 2.3rem;
      }

      .topbar h1 {
        font-size: 2rem;
      }
    }

    @media (max-width: 640px) {
      .topbar {
        height: auto;
        padding: 12px 10px 8px;
        display: block;
      }

      .btn-back {
        position: static;
        transform: none;
        display: inline-block;
        margin-bottom: 8px;
      }

      .topbar h1 {
        display: inline-block;
        font-size: 1.6rem;
      }

      .layout {
        padding: 0 12px 16px;
        gap: 16px;
      }

      .orders-shell,
      .report-shell {
        border-radius: 18px;
        padding: 16px 14px;
      }

      .order-title {
        font-size: 1.7rem;
      }

      .order-items-title {
        font-size: 1.9rem;
      }

      .report-header {
        flex-direction: column;
        align-items: flex-start;
      }

      .bar-row {
        grid-template-columns: 82px 1fr 44px;
      }
    }
  </style>
</head>
<body>
  <header class="topbar">
    <a class="btn-back" href="admin.php">Voltar ao admin</a>
    <h1>Cantina</h1>
  </header>

  <main class="layout">
    <section class="orders-shell">
      <p id="ordersStatus" class="status">Carregando pedidos...</p>
      <div id="ordersList" class="orders-list"></div>
    </section>

    <section class="report-shell">
      <div class="report-header">
        <h2 class="report-title">Relatorio de vendas</h2>
        <input type="month" id="reportMonth" />
      </div>
      <div id="reportBars" class="report-bars"></div>
    </section>
  </main>

  <script src="pedidos.js"></script>
</body>
</html>
