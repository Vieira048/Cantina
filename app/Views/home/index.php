<!DOCTYPE html>
<html lang="pt-BR">

<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Cantina - Home</title>
  <link rel="stylesheet" href="style.css" />
  <link rel="shortcut icon" href="favicon.ico" type="image/x-icon">
</head>

<body>
  <header class="topbar">
    <div class="logo">Cantina</div>
    <nav>
      <?php if (($tipoUsuario ?? null) === 'admin'): ?>
        <a href="admin.php" class="btn link-admin">Painel ADM</a>
      <?php endif; ?>

      <?php if (!empty($logado)): ?>
        <a href="deslogar.php" class="btn link-login">Deslogar</a>
      <?php else: ?>
        <a href="login.php" class="btn link-login">Login / Registrar</a>
      <?php endif; ?>

      <button id="abrirCarrinho" class="btn">Carrinho (<span id="contador">0</span>)</button>
    </nav>
  </header>

  <main class="container">
    <section class="hero">
      <div class="window">
        <div class="window-inner">
          <h1>Cardapio</h1>
          <div class="subtitle">Nossas melhores opcoes</div>
        </div>
      </div>
    </section>

    <section id="produtos" class="grid-sections"></section>
  </main>

  <aside id="carrinho" class="cart">
    <div class="cart-header">
      <h2>Seu Carrinho</h2>
      <button id="fecharCarrinho" class="close">X</button>
    </div>
    <div id="itensCarrinho" class="cart-items"></div>
    <div class="cart-footer">
      <div class="total">Total: R$ <span id="total">0.00</span></div>
      <div class="cart-actions">
        <button id="limparCarrinho" class="btn outline">Limpar</button>
        <button id="finalizar" class="btn primary">Finalizar</button>
      </div>
    </div>
  </aside>

  <script src="script.js"></script>
</body>

<footer class="footer">
  <div class="footer-content">
    <div class="footer-section">
      <h3>Sobre Nos</h3>
      <p>Somos uma equipe dedicada a fornecer o melhor PI ja feito.</p>
    </div>

    <div class="footer-section">
      <h3>Contato</h3>
      <ul class="contact-info">
        <li>(48) 99603-1418</li>
        <li>saborestecnicos@gmail.com</li>
        <li>Gaspar, SC</li>
      </ul>
    </div>

    <div class="footer-section">
      <h3>Redes Sociais</h3>
      <div class="social-links">
        <a href="https://www.instagram.com/vitorv1e1ra/" target="_blank">Vieira</a>
        <a href="https://www.instagram.com/leticia.almeidamomo/" target="_blank">Lelet</a>
      </div>
    </div>
  </div>

  <div class="footer-bottom">
    <p>&copy; 2025 Cantina. Todos os direitos reservados.</p>
  </div>
</footer>

</html>
