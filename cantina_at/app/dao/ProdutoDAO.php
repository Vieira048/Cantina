<?php

include("../config.php");

class ProdutoDAO {

    private $conexao;

    public function __construct(){

        $this->conexao = obterConexao();
    }


    public function listar(){

        $sql = "SELECT * FROM produtos";

        $resultado =
        mysqli_query($this->conexao, $sql);

        $lista = [];

        while($produto =
        mysqli_fetch_assoc($resultado)){

            $lista[] = $produto;
        }

        return $lista;
    }


    public function salvar($produto){

        $sql = "
        INSERT INTO produtos
        (id, name, category, price, desc, image)

        VALUES
        (?,?,?,?,?,?)
        ";

        $stmt = mysqli_prepare(
            $this->conexao,
            $sql
        );

        mysqli_stmt_bind_param(

            $stmt,

            "ssssds",

            $produto['id'],
            $produto['name'],
            $produto['category'],
            $produto['price'],
            $produto['desc'],
            $produto['image']
        );

        mysqli_stmt_execute($stmt);
    }


    public function remover($id){

        $sql = "DELETE FROM produtos WHERE id=?";

        $stmt = mysqli_prepare(
            $this->conexao,
            $sql
        );

        mysqli_stmt_bind_param(
            $stmt,
            "s",
            $id
        );

        mysqli_stmt_execute($stmt);
    }
}
?>