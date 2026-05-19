<?php
session_start();

$mensagem = null;

if (isset($_GET['erro'])) {

    switch ($_GET['erro']) {

        case 1:
            $mensagem = "Preencha todos os campos";
            break;

        case 2:
            $mensagem = "Email já cadastrado";
            break;

        case 3:
            $mensagem = "Erro ao cadastrar";
            break;

        case 4:
            $mensagem = "Erro interno";
            break;
    }
}

if (isset($_GET['cad']) && $_GET['cad'] == 'ok') {
    $mensagem = "Cadastro realizado com sucesso";
}
?>

<!DOCTYPE html>
<html lang="pt-BR">

<head>

    <meta charset="utf-8" />

    <meta name="viewport"
          content="width=device-width,initial-scale=1" />

    <title>Login - Cantina</title>

    <link rel="stylesheet"
          href="../../assets/css/style.css" />

    <link rel="shortcut icon"
          href="../../images/favicon.ico"
          type="image/x-icon">

</head>

<body>

<header class="topbar">

    <div class="logo">
        Cantina
    </div>

</header>

<main class="auth-page">

    <div class="auth-card">

        <?php if ($mensagem != null): ?>

            <div class="mensagem">

                <?= $mensagem ?>

            </div>

        <?php endif; ?>

        <div class="tabs-auth">

            <button id="btnShowLogin"
                    class="btn primary">

                Entrar

            </button>

            <button id="btnShowRegister"
                    class="btn outline">

                Registrar

            </button>

        </div>

        <!-- LOGIN -->

        <form id="loginForm"
              method="post"
              action="../controller/LoginController.php">

            <h2>Entrar</h2>

            <div class="field">

                <label>Email</label>

                <input type="email"
                       name="email"
                       required>

            </div>

            <div class="field">

                <label>Senha</label>

                <input type="password"
                       name="senha"
                       required>

            </div>

            <div style="display:flex; gap:8px;">

                <input type="submit"
                       value="Entrar"
                       class="btn primary">

                <a href="index.php"
                   class="btn outline">

                    Voltar

                </a>

            </div>

        </form>

        <!-- REGISTRO -->

        <form id="registerForm"
              style="display:none"
              method="post"
              action="../controller/RegisterController.php">

            <h2>Registrar</h2>

            <div class="field">

                <label>Nome</label>

                <input type="text"
                       name="nome"
                       required>

            </div>

            <div class="field">

                <label>Email</label>

                <input type="email"
                       name="email"
                       required>

            </div>

            <div class="field">

                <label>Senha</label>

                <input type="password"
                       name="senha"
                       required>

            </div>

            <div style="display:flex; gap:8px;">

                <button type="submit"
                        class="btn primary">

                    Registrar

                </button>

                <button type="button"
                        id="regCancelar"
                        class="btn outline">

                    Cancelar

                </button>

            </div>

        </form>

    </div>

</main>

<script src="../../assets/js/login.js"></script>

</body>
</html>