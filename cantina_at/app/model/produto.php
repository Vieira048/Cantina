<?php

require_once __DIR__ . '/../../config/database.php';

class Produto {

    private $conn;

    public function __construct() {

        $this->conn = obterConexao();

    }

    public function listar() {

        $sql = "SELECT * FROM produtos";

        $result = mysqli_query($this->conn, $sql);

        $dados = [];

        while ($row = mysqli_fetch_assoc($result)) {

            $dados[] = $row;

        }

        return $dados;

    }

}