<?php
declare(strict_types=1);

namespace App\Models;

use App\Core\Database;
use mysqli;

final class UserModel
{
    private mysqli $conn;

    public function __construct()
    {
        $this->conn = Database::connection();
    }

    public function findByEmail(string $email): ?array
    {
        $stmt = $this->conn->prepare('SELECT id, nome, email, senha, tipo FROM usuarios WHERE email = ? LIMIT 1');
        $stmt->bind_param('s', $email);
        $stmt->execute();

        $result = $stmt->get_result();
        $user = $result ? $result->fetch_assoc() : null;

        return $user ?: null;
    }

    public function emailExists(string $email): bool
    {
        $stmt = $this->conn->prepare('SELECT id FROM usuarios WHERE email = ? LIMIT 1');
        $stmt->bind_param('s', $email);
        $stmt->execute();

        $result = $stmt->get_result();
        return (bool) ($result && $result->fetch_assoc());
    }

    public function create(string $nome, string $email, string $senhaHash): int
    {
        $stmt = $this->conn->prepare('INSERT INTO usuarios (nome, email, senha) VALUES (?, ?, ?)');
        $stmt->bind_param('sss', $nome, $email, $senhaHash);
        $stmt->execute();

        return (int) $stmt->insert_id;
    }
}
