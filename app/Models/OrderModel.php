<?php
declare(strict_types=1);

namespace App\Models;

use App\Core\Database;
use RuntimeException;
use mysqli;
use Throwable;

final class OrderModel
{
    private mysqli $conn;
    private string $orderCreatedAtColumn;

    public function __construct()
    {
        $this->conn = Database::connection();
        $this->orderCreatedAtColumn = $this->detectCreatedAtColumn();
    }

    public function listRecentWithUser(int $limit = 100): array
    {
        $limit = max(1, $limit);
        $column = $this->orderCreatedAtColumn;

        $sql = "SELECT p.id, p.usuario_id, p.valor_total, p.status, p.$column AS criado_em, u.nome AS usuario_nome, u.email AS usuario_email
                FROM pedidos p
                LEFT JOIN usuarios u ON u.id = p.usuario_id
                ORDER BY p.id DESC
                LIMIT ?";

        $stmt = $this->conn->prepare($sql);
        $stmt->bind_param('i', $limit);
        $stmt->execute();

        $result = $stmt->get_result();
        $orders = [];
        while ($row = $result->fetch_assoc()) {
            $orders[] = [
                'id' => (int) $row['id'],
                'usuario_id' => $row['usuario_id'] !== null ? (int) $row['usuario_id'] : null,
                'usuario_nome' => (string) ($row['usuario_nome'] ?? ''),
                'usuario_email' => (string) ($row['usuario_email'] ?? ''),
                'valor_total' => (float) $row['valor_total'],
                'status' => (string) $row['status'],
                'criado_em' => (string) $row['criado_em'],
            ];
        }

        return $orders;
    }

    public function createFromItems(int $usuarioId, array $items): array
    {
        $this->conn->begin_transaction();

        try {
            $valorTotal = 0.0;
            $status = 'pendente';

            $stmtOrder = $this->conn->prepare('INSERT INTO pedidos (usuario_id, valor_total, status) VALUES (?, ?, ?)');
            $stmtOrder->bind_param('ids', $usuarioId, $valorTotal, $status);
            $stmtOrder->execute();
            $orderId = (int) $stmtOrder->insert_id;

            $stmtProduct = $this->conn->prepare('SELECT id, nome, preco FROM produtos WHERE id = ? AND ativo = 1 LIMIT 1');
            $stmtItem = $this->conn->prepare('INSERT INTO pedido_itens (pedido_id, produto_id, nome_produto, quantidade, preco_unitario, configuracao) VALUES (?, ?, ?, ?, ?, ?)');

            foreach ($items as $item) {
                if (!is_array($item)) {
                    continue;
                }

                $productId = (int) ($item['id_produto'] ?? 0);
                $qty = max(1, (int) ($item['quantidade'] ?? 1));
                if ($productId <= 0) {
                    continue;
                }

                $stmtProduct->bind_param('i', $productId);
                $stmtProduct->execute();
                $productResult = $stmtProduct->get_result();
                $product = $productResult ? $productResult->fetch_assoc() : null;
                if (!$product) {
                    continue;
                }

                $unitPrice = (float) ($item['preco_unitario'] ?? 0);
                if ($unitPrice <= 0) {
                    $unitPrice = (float) $product['preco'];
                }

                $name = trim((string) ($item['nome_produto'] ?? ''));
                if ($name === '') {
                    $name = (string) $product['nome'];
                }

                $configuration = null;
                if (isset($item['configuracao']) && is_array($item['configuracao'])) {
                    $configuration = json_encode($item['configuracao'], JSON_UNESCAPED_UNICODE);
                }

                $stmtItem->bind_param('iisids', $orderId, $productId, $name, $qty, $unitPrice, $configuration);
                $stmtItem->execute();

                $valorTotal += $qty * $unitPrice;
            }

            if ($valorTotal <= 0) {
                throw new RuntimeException('Nao foi possivel montar os itens do pedido.');
            }

            $stmtUpdate = $this->conn->prepare('UPDATE pedidos SET valor_total = ? WHERE id = ?');
            $stmtUpdate->bind_param('di', $valorTotal, $orderId);
            $stmtUpdate->execute();

            $this->conn->commit();

            return [
                'pedido_id' => $orderId,
                'valor_total' => $valorTotal,
            ];
        } catch (Throwable $e) {
            $this->conn->rollback();
            throw $e;
        }
    }

    private function detectCreatedAtColumn(): string
    {
        $result = $this->conn->query("SHOW COLUMNS FROM pedidos LIKE 'criado_em'");
        if ($result && $result->fetch_assoc()) {
            return 'criado_em';
        }

        return 'data_pedido';
    }
}
