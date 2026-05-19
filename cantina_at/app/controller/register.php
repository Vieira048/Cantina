<?php

require_once("../../config/config.php");

$conexao = obterConexao();

$nome  = $_POST['nome']  ?? null;
$email = $_POST['email'] ?? null;
$senha = $_POST['senha'] ?? null;

if (!$nome || !$email || !$senha) {
    header("Location: ../view/login.php?erro=1");
    exit;
}

/*
|--------------------------------------------------------------------------
| VERIFICA SE O EMAIL JÁ EXISTE
|--------------------------------------------------------------------------
*/

$stmtCheck = mysqli_prepare(
    $conexao,
    "SELECT id FROM usuarios WHERE email = ?"
);

mysqli_stmt_bind_param($stmtCheck, "s", $email);

mysqli_stmt_execute($stmtCheck);

$result = mysqli_stmt_get_result($stmtCheck);

if (mysqli_num_rows($result) > 0) {

    header("Location: ../view/login.php?erro=2");
    exit;
}

/*
|--------------------------------------------------------------------------
| CADASTRAR USUÁRIO
|--------------------------------------------------------------------------
*/

$stmt = mysqli_prepare(
    $conexao,
    "INSERT INTO usuarios (nome, email, senha)
     VALUES (?, ?, ?)"
);

mysqli_stmt_bind_param(
    $stmt,
    "sss",
    $nome,
    $email,
    $senha
);

try {

    $cadastro = mysqli_stmt_execute($stmt);

    if ($cadastro) {

        header("Location: ../view/login.php?cad=ok");
        exit;

    } else {

        header("Location: ../view/login.php?erro=3");
        exit;
    }

} catch (Throwable $e) {

    header("Location: ../view/login.php?erro=4");
    exit;
}