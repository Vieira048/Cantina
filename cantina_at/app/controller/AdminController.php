<?php

session_start();

if (!isset($_SESSION['tipo']) || $_SESSION['tipo'] != "admin") {

    header("Location: ../login.php");
    exit;
}

include("../view/admin.php");

?>