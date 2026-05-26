<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\SessionAuth;

final class HomeController extends Controller
{
    public function index(): void
    {
        SessionAuth::start();

        $this->render('home/index', [
            'logado' => SessionAuth::isLoggedIn(),
            'tipoUsuario' => SessionAuth::userType(),
        ]);
    }
}
