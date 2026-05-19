<!DOCTYPE html>
<html lang="pt-BR">

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">

    <title>Monte sua Marmita</title>

    <link rel="stylesheet" href="/cantina/public/css/style.css">

</head>

<body>

<main class="container">

    <div class="marmita-box">

        <h2>Monte sua Marmita</h2>

        <form id="formMarmita">

            <div class="field">

                <label>Tamanho</label>

                <select id="marmitaTamanho"></select>

            </div>

            <div id="marmitaOpcoes"></div>

            <div id="marmitaValor">
                Valor: R$ 0,00
            </div>

            <div class="form-actions">

                <button type="submit" class="btn primary">
                    Adicionar ao carrinho
                </button>

                <a href="/cantina/public/" class="btn outline">
                    Cancelar
                </a>

            </div>

        </form>

    </div>

</main>

<script src="/cantina/public/js/marmita.js"></script>

</body>
</html>