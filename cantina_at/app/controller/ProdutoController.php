<?php

include("../model/ProdutoDAO.php");

$dao = new ProdutoDAO();


if($_SERVER['REQUEST_METHOD'] == 'GET'){

    if($_GET['acao'] == 'listar'){

        echo json_encode(
            $dao->listar()
        );
    }
}


if($_SERVER['REQUEST_METHOD'] == 'POST'){

    $dados = json_decode(
        file_get_contents("php://input"),
        true
    );

    $dao->salvar($dados);
}


if($_SERVER['REQUEST_METHOD'] == 'DELETE'){

    $id = $_GET['id'];

    $dao->remover($id);
}
?>