<?php
session_start();
?>

<!DOCTYPE html>
<html lang="pt-BR">

<head>

    <meta charset="UTF-8">

    <title>Cantina</title>

    <link rel="stylesheet" href="/cantina/public/css/style.css">

</head>

<body>

<header class="topbar">

    <div class="logo">
        Cantina
    </div>

</header>

<main class="container">

    <section class="hero">

        <div class="window">

            <div class="window-inner">

                <h1>Cardápio</h1>

                <div class="subtitle">
                    Nossas melhores opções
                </div>

            </div>

        </div>

    </section>

    <section>

        <div class="section-title">
            Produtos
        </div>

        <div id="produtos" class="cards">

        </div>

    </section>

</main>

<script src="/cantina/public/js/script.js"></script>

</body>
</html>