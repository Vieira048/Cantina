<?php
declare(strict_types=1);

namespace App\Controllers\Api;

use App\Core\JsonResponse;
use App\Core\SessionAuth;
use App\Models\OrderModel;
use RuntimeException;
use Throwable;

final class OrderApiController
{
    private OrderModel $orders;

    public function __construct()
    {
        $this->orders = new OrderModel();
    }

    public function handle(): void
    {
        $method = strtoupper((string) ($_SERVER['REQUEST_METHOD'] ?? 'GET'));
        if (!in_array($method, ['GET', 'POST'], true)) {
            header('Allow: GET, POST');
            JsonResponse::send(405, ['ok' => false, 'message' => 'Metodo nao permitido.']);
        }

        try {
            if ($method === 'GET') {
                $this->assertAdmin();
                JsonResponse::send(200, ['ok' => true, 'data' => $this->orders->listRecentWithUser(100)]);
            }

            $this->assertLoggedIn();
            $data = $this->readJsonBody();
            $items = $data['itens'] ?? [];

            if (!is_array($items) || count($items) === 0) {
                JsonResponse::send(422, ['ok' => false, 'message' => 'Pedido sem itens.']);
            }

            $userId = SessionAuth::userId();
            if ($userId === null) {
                JsonResponse::send(401, ['ok' => false, 'message' => 'Sessao invalida.']);
            }

            try {
                $result = $this->orders->createFromItems($userId, $items);
            } catch (RuntimeException $e) {
                JsonResponse::send(422, ['ok' => false, 'message' => $e->getMessage()]);
            }

            JsonResponse::send(201, [
                'ok' => true,
                'message' => 'Pedido registrado com sucesso.',
                'data' => $result,
            ]);
        } catch (Throwable $e) {
            JsonResponse::send(500, ['ok' => false, 'message' => 'Erro interno ao processar pedido.']);
        }
    }

    private function readJsonBody(): array
    {
        $raw = file_get_contents('php://input');
        if ($raw === false || trim($raw) === '') {
            return [];
        }

        $data = json_decode($raw, true);
        if (!is_array($data)) {
            JsonResponse::send(400, ['ok' => false, 'message' => 'JSON invalido.']);
        }

        return $data;
    }

    private function assertLoggedIn(): void
    {
        SessionAuth::start();
        if (!SessionAuth::isLoggedIn()) {
            JsonResponse::send(401, ['ok' => false, 'message' => 'Login obrigatorio.']);
        }
    }

    private function assertAdmin(): void
    {
        $this->assertLoggedIn();
        if (SessionAuth::userType() !== 'admin') {
            JsonResponse::send(403, ['ok' => false, 'message' => 'Apenas administradores podem executar esta acao.']);
        }
    }
}
