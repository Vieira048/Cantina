<!DOCTYPE html>
<html lang="pt-BR">

<head>

    <meta charset="utf-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>Painel Admin - Cantina</title>

    <link rel="stylesheet" href="../style.css">

    <link rel="shortcut icon"
          href="../favicon.ico"
          type="image/x-icon">

</head>

<body>

<header class="topbar">

    <div class="logo">
        Cantina - ADM
    </div>

    <nav>
        <a href="../index.php" class="btn">
            Voltar ao Site
        </a>
    </nav>

</header>

<main class="container admin-grid">

    <div class="tabs">

        <button id="tabProdutos"
                class="btn primary">

            Produtos

        </button>

        <button id="tabMarmitas"
                class="btn outline">

            Marmitas

        </button>

    </div>

    <section id="secProdutos"
             class="card admin-card">

        <h2>Adicionar Produto</h2>

        <form id="formProduto">

            <input type="hidden"
                   id="produtoId">

            <div class="field">

                <label>Nome</label>

                <input id="nome">

            </div>

            <div class="field">

                <label>Categoria</label>

                <select id="categoria">

                    <option value="salgados">Salgados</option>

                    <option value="produtos">Produtos</option>

                    <option value="refrigerantes">Bebidas</option>

                    <option value="combos">Combos</option>

                </select>

            </div>

            <div class="field">

                <label>Preço</label>

                <input type="number"
                       id="preco">

            </div>

            <div class="field">

                <label>Descrição</label>

                <textarea id="descricao"></textarea>

            </div>

            <div class="field">

                <label>Foto</label>

                <input id="fotoUrl">

            </div>

            <button type="submit"
                    class="btn primary">

                Salvar Produto

            </button>

        </form>

    </section>

    <section class="card admin-card">

        <h2>Produtos Cadastrados</h2>

        <div id="listaProdutos"></div>

    </section>

</main>

<script src="../js/admin.js"></script>

</body>
</html>