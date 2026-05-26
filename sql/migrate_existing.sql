USE sabores_tecnicos;

-- Ajustes de usuarios para login por sessao + cadastro
ALTER TABLE usuarios
  MODIFY COLUMN nome VARCHAR(120) NOT NULL,
  MODIFY COLUMN email VARCHAR(190) NOT NULL,
  MODIFY COLUMN senha VARCHAR(255) NOT NULL,
  MODIFY COLUMN tipo ENUM('aluno','funcionario','admin','cliente') NOT NULL DEFAULT 'cliente';

-- Estrutura nova de produtos sem remover estrutura antiga
ALTER TABLE produtos
  ADD COLUMN IF NOT EXISTS categoria VARCHAR(50) NULL AFTER nome,
  ADD COLUMN IF NOT EXISTS imagem LONGTEXT NULL AFTER descricao,
  ADD COLUMN IF NOT EXISTS is_marmita TINYINT(1) NOT NULL DEFAULT 0 AFTER imagem,
  ADD COLUMN IF NOT EXISTS marmita_config LONGTEXT NULL AFTER is_marmita,
  ADD COLUMN IF NOT EXISTS ativo TINYINT(1) NOT NULL DEFAULT 1 AFTER marmita_config,
  ADD COLUMN IF NOT EXISTS criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ADD COLUMN IF NOT EXISTS atualizado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Popular categoria a partir da estrutura antiga (categoria_id)
UPDATE produtos p
LEFT JOIN categorias c ON c.id = p.categoria_id
SET p.categoria = COALESCE(NULLIF(TRIM(c.nome), ''), 'produtos')
WHERE p.categoria IS NULL OR p.categoria = '';

-- Popular status de ativo com base em disponibilidade antiga
UPDATE produtos
SET ativo = COALESCE(disponibilidade, 1)
WHERE ativo IS NULL OR ativo NOT IN (0,1);

ALTER TABLE produtos
  MODIFY COLUMN categoria VARCHAR(50) NOT NULL DEFAULT 'produtos';

CREATE INDEX IF NOT EXISTS idx_produtos_categoria ON produtos (categoria);
CREATE INDEX IF NOT EXISTS idx_produtos_ativo ON produtos (ativo);

-- Ajustes de pedidos
UPDATE pedidos SET valor_total = 0.00 WHERE valor_total IS NULL;
ALTER TABLE pedidos
  MODIFY COLUMN valor_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  MODIFY COLUMN status ENUM('pendente','preparando','pronto','finalizado','cancelado') DEFAULT 'pendente';

-- Tabela para itens de pedido usada pela API nova
CREATE TABLE IF NOT EXISTS pedido_itens (
  id INT(11) NOT NULL AUTO_INCREMENT,
  pedido_id INT(11) NOT NULL,
  produto_id INT(11) NULL,
  nome_produto VARCHAR(120) NOT NULL,
  quantidade INT(11) NOT NULL,
  preco_unitario DECIMAL(10,2) NOT NULL,
  configuracao LONGTEXT NULL,
  criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_pedido_itens_pedido (pedido_id),
  KEY idx_pedido_itens_produto (produto_id),
  CONSTRAINT fk_pedido_itens_pedido FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pedido_itens_produto FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Seed admin para testes
INSERT INTO usuarios (nome, email, senha, tipo)
SELECT 'Administrador', 'admin@cantina.local', '$2y$10$N1gjtDglWTZ2VI70kqH7uuoo7xvZueEXg5N/EK2SD0wExAlYh501G', 'admin'
WHERE NOT EXISTS (SELECT 1 FROM usuarios WHERE email = 'admin@cantina.local');
