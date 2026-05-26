<?php
declare(strict_types=1);

namespace App\Controllers;

use App\Core\Controller;
use App\Core\SessionAuth;
use App\Models\UserModel;
use mysqli_sql_exception;
use Throwable;

final class AuthController extends Controller
{
    private UserModel $users;

    public function __construct()
    {
        $this->users = new UserModel();
    }

    public function login(): void
    {
        SessionAuth::start();

        if (SessionAuth::isLoggedIn()) {
            $this->redirect('index.php');
        }

        if (strtoupper((string) ($_SERVER['REQUEST_METHOD'] ?? 'GET')) === 'POST') {
            $email = trim((string) ($_POST['email'] ?? ''));
            $senha = (string) ($_POST['senha'] ?? '');

            if ($email === '' || $senha === '') {
                $this->redirect('login.php?erro=campos');
            }

            try {
                $usuario = $this->users->findByEmail($email);
                if (!$usuario || !password_verify($senha, (string) $usuario['senha'])) {
                    $this->redirect('login.php?erro=credenciais');
                }

                SessionAuth::login($usuario);
                $this->redirect('index.php');
            } catch (Throwable $e) {
                $this->redirect('login.php?erro=sistema');
            }
        }

        $this->render('auth/login', [
            'mensagem' => $this->resolveMessage(),
            'showRegister' => ((string) ($_GET['ctx'] ?? '')) === 'register',
        ]);
    }

    public function register(): void
    {
        if (strtoupper((string) ($_SERVER['REQUEST_METHOD'] ?? 'GET')) !== 'POST') {
            $this->redirect('login.php');
        }

        $nome = trim((string) ($_POST['nome'] ?? ''));
        $email = trim((string) ($_POST['email'] ?? ''));
        $senha = (string) ($_POST['senha'] ?? '');

        if ($nome === '' || $email === '' || $senha === '') {
            $this->redirect('login.php?erro=campos&ctx=register');
        }

        if (!$this->isEmailFormatoValido($email)) {
            $this->redirect('login.php?erro=email_invalido&ctx=register');
        }

        if (strlen($senha) < 6) {
            $this->redirect('login.php?erro=senha_curta&ctx=register');
        }

        try {
            if ($this->users->emailExists($email)) {
                $this->redirect('login.php?erro=email_existe&ctx=register');
            }

            $hash = password_hash($senha, PASSWORD_DEFAULT);
            $this->users->create($nome, $email, $hash);
            $this->redirect('login.php?cad=ok');
        } catch (mysqli_sql_exception $e) {
            if ($e->getCode() === 1062) {
                $this->redirect('login.php?erro=email_existe&ctx=register');
            }

            if ($e->getCode() === 1406) {
                $this->redirect('login.php?erro=email_grande&ctx=register');
            }

            if (in_array($e->getCode(), [1265, 1366], true)) {
                $this->redirect('login.php?erro=schema_incompativel&ctx=register');
            }

            error_log('Erro SQL no cadastro: ' . $e->getMessage());
            $this->redirect('login.php?erro=sistema');
        } catch (Throwable $e) {
            error_log('Erro inesperado no cadastro: ' . $e->getMessage());
            $this->redirect('login.php?erro=sistema');
        }
    }

    public function logout(): void
    {
        SessionAuth::logout();
        $this->redirect('login.php?logout=ok');
    }

    private function resolveMessage(): ?string
    {
        if (isset($_GET['erro'])) {
            $erro = (string) $_GET['erro'];
            if ($erro === 'credenciais') {
                return 'Email ou senha invalidos.';
            }
            if ($erro === 'email_existe') {
                return 'Ja existe uma conta com esse email.';
            }
            if ($erro === 'email_invalido') {
                return 'Informe um email valido.';
            }
            if ($erro === 'senha_curta') {
                return 'A senha precisa ter pelo menos 6 caracteres.';
            }
            if ($erro === 'email_grande') {
                return 'O email informado e muito longo.';
            }
            if ($erro === 'schema_incompativel') {
                return 'O banco esta com estrutura antiga. Rode o arquivo sql/migrate_existing.sql.';
            }
            if ($erro === 'campos') {
                return 'Preencha os campos obrigatorios.';
            }
            if ($erro === 'acesso') {
                return 'Acesso permitido apenas para administradores.';
            }
            if ($erro === 'login') {
                return 'Faca login para continuar.';
            }

            return 'Erro inesperado ao autenticar.';
        }

        if (isset($_GET['cad']) && (string) $_GET['cad'] === 'ok') {
            return 'Cadastro realizado com sucesso. Agora faca login.';
        }

        if (isset($_GET['logout']) && (string) $_GET['logout'] === 'ok') {
            return 'Sessao encerrada com sucesso.';
        }

        return null;
    }

    private function isEmailFormatoValido(string $email): bool
    {
        $email = trim($email);
        if ($email === '') {
            return false;
        }

        $parts = explode('@', $email);
        if (count($parts) !== 2) {
            return false;
        }

        $local = trim($parts[0]);
        $domain = trim($parts[1]);

        return $local !== '' && $domain !== '';
    }
}
