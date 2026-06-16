-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: sabores_tecnicos
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `sabores_tecnicos`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `sabores_tecnicos` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `sabores_tecnicos`;

--
-- Table structure for table `carrinho`
--

DROP TABLE IF EXISTS `carrinho`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `carrinho` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `usuario_id` (`usuario_id`),
  CONSTRAINT `carrinho_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carrinho`
--

LOCK TABLES `carrinho` WRITE;
/*!40000 ALTER TABLE `carrinho` DISABLE KEYS */;
/*!40000 ALTER TABLE `carrinho` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `categorias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estoque`
--

DROP TABLE IF EXISTS `estoque`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `estoque` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `produto_id` int(11) DEFAULT NULL,
  `quantidade` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `produto_id` (`produto_id`),
  CONSTRAINT `estoque_ibfk_1` FOREIGN KEY (`produto_id`) REFERENCES `produtos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estoque`
--

LOCK TABLES `estoque` WRITE;
/*!40000 ALTER TABLE `estoque` DISABLE KEYS */;
/*!40000 ALTER TABLE `estoque` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itens_carrinho`
--

DROP TABLE IF EXISTS `itens_carrinho`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itens_carrinho` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `carrinho_id` int(11) DEFAULT NULL,
  `produto_id` int(11) DEFAULT NULL,
  `quantidade` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `carrinho_id` (`carrinho_id`),
  KEY `produto_id` (`produto_id`),
  CONSTRAINT `itens_carrinho_ibfk_1` FOREIGN KEY (`carrinho_id`) REFERENCES `carrinho` (`id`),
  CONSTRAINT `itens_carrinho_ibfk_2` FOREIGN KEY (`produto_id`) REFERENCES `produtos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itens_carrinho`
--

LOCK TABLES `itens_carrinho` WRITE;
/*!40000 ALTER TABLE `itens_carrinho` DISABLE KEYS */;
/*!40000 ALTER TABLE `itens_carrinho` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `itens_pedido`
--

DROP TABLE IF EXISTS `itens_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `itens_pedido` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pedido_id` int(11) DEFAULT NULL,
  `produto_id` int(11) DEFAULT NULL,
  `quantidade` int(11) NOT NULL,
  `preco_unitario` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `pedido_id` (`pedido_id`),
  KEY `produto_id` (`produto_id`),
  CONSTRAINT `itens_pedido_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`),
  CONSTRAINT `itens_pedido_ibfk_2` FOREIGN KEY (`produto_id`) REFERENCES `produtos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `itens_pedido`
--

LOCK TABLES `itens_pedido` WRITE;
/*!40000 ALTER TABLE `itens_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `itens_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pagamentos`
--

DROP TABLE IF EXISTS `pagamentos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pagamentos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pedido_id` int(11) DEFAULT NULL,
  `tipo` enum('dinheiro','cartao','pix') DEFAULT NULL,
  `status` enum('pendente','pago','cancelado') DEFAULT 'pendente',
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_pagamentos_pedido` (`pedido_id`),
  KEY `idx_pagamentos_status` (`status`),
  CONSTRAINT `pagamentos_ibfk_1` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagamentos`
--

LOCK TABLES `pagamentos` WRITE;
/*!40000 ALTER TABLE `pagamentos` DISABLE KEYS */;
INSERT INTO `pagamentos` VALUES (5,20,'dinheiro','pendente','2026-05-27 17:06:02'),(6,21,'pix','pendente','2026-05-27 17:17:14'),(7,22,'pix','pendente','2026-05-27 17:17:26'),(8,23,'cartao','pendente','2026-05-27 17:19:49'),(10,25,'dinheiro','pendente','2026-05-27 17:33:24'),(14,29,'dinheiro','pendente','2026-05-27 18:20:50'),(15,30,'dinheiro','pendente','2026-05-27 18:22:11'),(16,31,'cartao','pendente','2026-05-27 18:32:28'),(17,32,'pix','pendente','2026-05-27 18:32:39'),(20,35,'dinheiro','pendente','2026-05-27 20:03:26'),(21,36,'dinheiro','pendente','2026-05-27 20:03:47'),(22,37,'dinheiro','pendente','2026-05-27 20:24:15'),(23,38,'pix','pendente','2026-05-27 20:43:26'),(24,39,'pix','pendente','2026-05-27 21:14:43'),(25,40,'pix','pendente','2026-05-27 21:56:56'),(26,41,'cartao','pendente','2026-05-28 19:26:10'),(27,42,'dinheiro','pendente','2026-05-28 19:36:38'),(28,43,'pix','pendente','2026-05-28 20:03:46'),(29,44,'dinheiro','pendente','2026-05-28 22:37:30'),(30,45,'dinheiro','pendente','2026-06-02 11:02:45'),(31,46,'dinheiro','pendente','2026-06-02 11:17:52'),(32,47,'pix','pendente','2026-06-02 11:48:34'),(33,48,'dinheiro','pendente','2026-06-03 13:56:34'),(34,49,'dinheiro','cancelado','2026-06-03 14:17:09'),(35,50,'dinheiro','cancelado','2026-06-06 16:58:08'),(36,51,'dinheiro','cancelado','2026-06-06 19:39:39'),(37,52,'pix','cancelado','2026-06-06 20:03:44'),(38,53,'dinheiro','pendente','2026-06-06 20:22:13'),(39,54,'pix','pendente','2026-06-07 12:29:14'),(40,55,'pix','pendente','2026-06-08 23:42:05'),(41,56,'pix','cancelado','2026-06-08 23:42:28');
/*!40000 ALTER TABLE `pagamentos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedido_itens`
--

DROP TABLE IF EXISTS `pedido_itens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedido_itens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pedido_id` int(11) NOT NULL,
  `produto_id` int(11) DEFAULT NULL,
  `nome_produto` varchar(120) NOT NULL,
  `quantidade` int(11) NOT NULL,
  `preco_unitario` decimal(10,2) NOT NULL,
  `configuracao` longtext DEFAULT NULL,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_pedido_itens_pedido` (`pedido_id`),
  KEY `idx_pedido_itens_produto` (`produto_id`),
  CONSTRAINT `fk_pedido_itens_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pedido_itens_produto` FOREIGN KEY (`produto_id`) REFERENCES `produtos` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedido_itens`
--

LOCK TABLES `pedido_itens` WRITE;
/*!40000 ALTER TABLE `pedido_itens` DISABLE KEYS */;
INSERT INTO `pedido_itens` VALUES (1,1,NULL,'Produto Teste API Fluxo',2,15.75,NULL,'2026-05-26 18:06:42'),(2,2,NULL,'Produto Teste MVC',2,18.25,NULL,'2026-05-26 18:16:33'),(3,3,9,'Pastel',1,9.50,NULL,'2026-05-26 18:50:01'),(4,4,16,'Marmita do Ratão',1,19.00,'{\"tamanho\":\"P\",\"carbo\":\"Macarrão\",\"proteinas\":[\"Frango maromba\"],\"saladas\":[\"Alface\",\"Tomate\",\"Pepino\"],\"adicionais\":[\"Batata-frita\",\"Banana\"]}','2026-05-26 19:29:10'),(5,4,13,'Chá Matte Leão',1,4.50,NULL,'2026-05-26 19:29:10'),(6,4,17,'Pastel',67,9.50,NULL,'2026-05-26 19:29:10'),(7,5,12,'Coxinha',1,9.00,NULL,'2026-05-26 19:40:15'),(8,5,11,'Pastel',1,9.50,NULL,'2026-05-26 19:40:15'),(9,6,13,'Chá Matte Leão',2,4.50,NULL,'2026-05-26 19:41:18'),(12,9,16,'Marmita do Ratão',1,19.00,'{\"tamanho\":\"P\",\"carbo\":\"Arroz\",\"proteinas\":[],\"saladas\":[],\"adicionais\":[]}','2026-05-27 00:22:08'),(13,10,18,'CODEx TESTE PRODUTO',1,9.50,NULL,'2026-05-27 00:22:27'),(14,11,14,'Coca-cola 600ml',1,7.50,NULL,'2026-05-27 01:52:19'),(15,11,9,'Pastel',1,9.50,NULL,'2026-05-27 01:52:19'),(16,12,10,'Pastel',1,9.49,NULL,'2026-05-27 01:52:24'),(17,12,13,'Chá Matte Leão',1,4.50,NULL,'2026-05-27 01:52:24'),(18,13,16,'Marmita do Ratão',1,19.00,'{\"tamanho\":\"P\",\"carbo\":\"Macarrão\",\"proteinas\":[\"Carne de Boi Litorâneo\"],\"saladas\":[\"Alface\"],\"adicionais\":[\"Batata-frita\"]}','2026-05-27 12:58:21'),(19,13,13,'Chá Matte Leão',2,4.50,NULL,'2026-05-27 12:58:21'),(20,14,10,'Pastel',1,9.49,NULL,'2026-05-27 13:30:04'),(21,14,9,'Pastel',1,9.50,NULL,'2026-05-27 13:30:04'),(22,14,11,'Pastel',1,9.50,NULL,'2026-05-27 13:30:04'),(23,14,12,'Coxinha',1,9.00,NULL,'2026-05-27 13:30:04'),(24,14,14,'Coca-cola 600ml',2,7.50,NULL,'2026-05-27 13:30:04'),(25,14,16,'Marmita do Ratão',1,19.00,'{\"tamanho\":\"P\",\"carbo\":\"Arroz\",\"proteinas\":[\"Carne de cordeiro Suiço\",\"Carne de Boi Litorâneo\"],\"saladas\":[\"Alface\",\"Pepino\"],\"adicionais\":[\"Batata-frita\",\"Farofa\"]}','2026-05-27 13:30:04'),(26,15,16,'Marmita do Ratão',1,19.00,'{\"tamanho\":\"P\",\"carbo\":\"Arroz\",\"proteinas\":[\"Carne de cordeiro Suiço\"],\"saladas\":[\"Tomate\"],\"adicionais\":[\"Batata-frita\"]}','2026-05-27 13:36:11'),(27,15,17,'Pastel',1,9.50,NULL,'2026-05-27 13:36:11'),(32,20,13,'Chá Matte Leão',1,4.50,NULL,'2026-05-27 17:06:02'),(33,20,14,'Coca-cola 600ml',1,7.50,NULL,'2026-05-27 17:06:02'),(34,20,9,'Pastel',1,9.50,NULL,'2026-05-27 17:06:02'),(35,21,9,'Pastel',1,9.50,NULL,'2026-05-27 17:17:14'),(36,22,9,'Pastel',1,9.50,NULL,'2026-05-27 17:17:26'),(37,23,14,'Coca-cola 600ml',2,7.50,NULL,'2026-05-27 17:19:49'),(38,23,9,'Pastel',3,9.50,NULL,'2026-05-27 17:19:49'),(40,25,9,'Pastel',2,9.50,NULL,'2026-05-27 17:33:24'),(41,25,13,'Chá Matte Leão',1,4.50,NULL,'2026-05-27 17:33:24'),(45,29,14,'Coca-cola 600ml',1,7.50,NULL,'2026-05-27 18:20:50'),(46,29,10,'Pastel',1,9.49,NULL,'2026-05-27 18:20:50'),(47,29,12,'Coxinha',1,9.00,NULL,'2026-05-27 18:20:50'),(48,30,16,'Marmita do Ratão',1,19.00,'{\"tamanho\":\"P\",\"carbo\":\"Macarrão\",\"proteinas\":[\"Carne de Boi Litorâneo\",\"Frango maromba\"],\"saladas\":[\"Alface\",\"Tomate\"],\"adicionais\":[\"Batata-frita\",\"Banana\"]}','2026-05-27 18:22:11'),(49,31,14,'Coca-cola 600ml',1,7.50,NULL,'2026-05-27 18:32:28'),(50,31,17,'Pastel',1,9.50,NULL,'2026-05-27 18:32:28'),(51,31,11,'Pastel',1,9.50,NULL,'2026-05-27 18:32:28'),(52,32,12,'Coxinha',1,9.00,NULL,'2026-05-27 18:32:39'),(53,32,9,'Pastel',1,9.50,NULL,'2026-05-27 18:32:39'),(56,35,19,'Bolacha',1,4.00,NULL,'2026-05-27 20:03:26'),(57,35,13,'Chá Matte Leão',1,4.50,NULL,'2026-05-27 20:03:26'),(58,35,9,'Pastel',1,9.50,NULL,'2026-05-27 20:03:26'),(59,36,19,'Bolacha',1,4.00,NULL,'2026-05-27 20:03:47'),(60,36,14,'Coca-cola 600ml',1,7.50,NULL,'2026-05-27 20:03:47'),(61,37,16,'Marmita do Ratão',1,25.00,'{\"tamanho\":\"M\",\"carbo\":\"Arroz\",\"proteinas\":[\"Carne de Boi Litorâneo\",\"Frango maromba\"],\"saladas\":[\"Alface\",\"Pepino\"],\"adicionais\":[\"Batata-frita\",\"Banana\"]}','2026-05-27 20:24:15'),(62,38,11,'Pastel',13,9.50,NULL,'2026-05-27 20:43:26'),(63,38,16,'Marmita do Ratão',1,19.00,'{\"tamanho\":\"P\",\"carbo\":\"Arroz\",\"proteinas\":[\"Carne de cordeiro Suiço\",\"Carne de Boi Litorâneo\",\"Carne de porco limpo\",\"Frango maromba\"],\"saladas\":[\"Alface\",\"Tomate\",\"Pepino\"],\"adicionais\":[\"Batata-frita\"]}','2026-05-27 20:43:26'),(64,39,14,'Coca-cola 600ml',1,7.50,NULL,'2026-05-27 21:14:43'),(65,39,12,'Coxinha',5,9.00,NULL,'2026-05-27 21:14:43'),(66,39,10,'Pastel',1,9.49,NULL,'2026-05-27 21:14:43'),(67,39,13,'Chá Matte Leão',1,4.50,NULL,'2026-05-27 21:14:43'),(68,40,16,'Marmita do Ratão',1,19.00,'{\"tamanho\":\"P\",\"carbo\":\"Macarrão\",\"proteinas\":[\"Carne de cordeiro Suiço\",\"Carne de Boi Litorâneo\",\"Carne de porco limpo\",\"Frango maromba\"],\"saladas\":[\"Alface\",\"Tomate\",\"Pepino\"],\"adicionais\":[\"Batata-frita\",\"Farofa\",\"Banana\"]}','2026-05-27 21:56:56'),(69,41,19,'Bolacha',1,4.00,NULL,'2026-05-28 19:26:10'),(70,41,13,'Chá Matte Leão',1,4.50,NULL,'2026-05-28 19:26:10'),(71,41,12,'Coxinha',1,9.00,NULL,'2026-05-28 19:26:10'),(72,42,16,'Marmita do Ratão',1,28.00,'{\"tamanho\":\"G\",\"carbo\":\"Arroz\",\"proteinas\":[\"Carne de cordeiro Suiço\",\"Carne de Boi Litorâneo\",\"Carne de porco limpo\",\"Frango maromba\"],\"saladas\":[\"Alface\",\"Tomate\",\"Pepino\"],\"adicionais\":[\"Batata-frita\",\"Farofa\",\"Banana\"]}','2026-05-28 19:36:38'),(73,42,19,'Bolacha',1,4.00,NULL,'2026-05-28 19:36:38'),(74,42,13,'Chá Matte Leão',7,4.50,NULL,'2026-05-28 19:36:38'),(75,42,17,'Pastel',7,9.50,NULL,'2026-05-28 19:36:38'),(76,42,12,'Coxinha',1,9.00,NULL,'2026-05-28 19:36:38'),(77,42,9,'Pastel',1,9.50,NULL,'2026-05-28 19:36:38'),(78,42,10,'Pastel',1,9.49,NULL,'2026-05-28 19:36:38'),(79,42,11,'Pastel',1,9.50,NULL,'2026-05-28 19:36:38'),(80,43,13,'Chá Matte Leão',1,4.50,NULL,'2026-05-28 20:03:46'),(81,43,14,'Coca-cola 600ml',1,7.50,NULL,'2026-05-28 20:03:46'),(82,43,12,'Coxinha',1,9.00,NULL,'2026-05-28 20:03:46'),(83,43,10,'Pastel',4,9.49,NULL,'2026-05-28 20:03:46'),(84,44,19,'Bolacha',1,4.00,NULL,'2026-05-28 22:37:30'),(85,44,14,'Coca-cola 600ml',1,7.50,NULL,'2026-05-28 22:37:30'),(86,44,13,'Chá Matte Leão',1,4.50,NULL,'2026-05-28 22:37:30'),(87,45,19,'Bolacha',1,4.00,NULL,'2026-06-02 11:02:45'),(88,45,13,'Chá Matte Leão',1,4.50,NULL,'2026-06-02 11:02:45'),(89,45,14,'Coca-cola 600ml',1,7.50,NULL,'2026-06-02 11:02:45'),(90,45,9,'Pastel',2,9.50,NULL,'2026-06-02 11:02:45'),(91,46,12,'Coxinha',2,9.00,NULL,'2026-06-02 11:17:52'),(92,46,9,'Pastel',1,9.50,NULL,'2026-06-02 11:17:52'),(93,46,17,'Pastel',1,9.50,NULL,'2026-06-02 11:17:52'),(94,46,14,'Coca-cola 600ml',1,7.50,NULL,'2026-06-02 11:17:52'),(95,46,19,'Bolacha',1,4.00,NULL,'2026-06-02 11:17:52'),(96,46,13,'Chá Matte Leão',1,4.50,NULL,'2026-06-02 11:17:52'),(97,47,19,'Bolacha',3,4.00,NULL,'2026-06-02 11:48:34'),(98,47,12,'Coxinha',1,9.00,NULL,'2026-06-02 11:48:34'),(99,48,16,'Marmita do Ratão',1,35.50,'{\"tamanho\":\"M\",\"carbo\":\"Macarrão\",\"carbos\":[\"Macarrão\"],\"proteinas\":[\"Carne de cordeiro Suiço\",\"Carne de porco limpo\"],\"saladas\":[\"Alface\",\"Tomate\",\"Pepino\"],\"adicionais\":[\"Batata-frita\",\"Farofa\"]}','2026-06-03 13:56:34'),(100,48,14,'Coca-cola 600ml',1,7.50,NULL,'2026-06-03 13:56:34'),(101,49,19,'Bolacha',1,4.00,NULL,'2026-06-03 14:17:09'),(102,49,13,'Chá Matte Leão',1,4.50,NULL,'2026-06-03 14:17:09'),(103,49,14,'Coca-cola 600ml',1,7.50,NULL,'2026-06-03 14:17:09'),(104,50,19,'Bolacha',1,4.00,NULL,'2026-06-06 16:58:08'),(105,50,14,'Coca-cola 600ml',1,7.50,NULL,'2026-06-06 16:58:08'),(106,50,13,'Chá Matte Leão',1,4.50,NULL,'2026-06-06 16:58:08'),(107,51,29,'Marmita do Dia',1,15.00,'{\"tamanho\":\"P\",\"carbo\":\"Macarrão\",\"proteinas\":[\"Carne de boi\",\"Carne de boi desfiada\"],\"saladas\":[\"Alface\"],\"adicionais\":[\"Ovo\"]}','2026-06-06 19:39:39'),(108,51,34,'Mini pizza de calabresa',1,11.00,NULL,'2026-06-06 19:39:39'),(109,51,30,'Coxinha de frango',1,7.00,NULL,'2026-06-06 19:39:39'),(110,52,35,'Mini pizza de frango',3,11.00,NULL,'2026-06-06 20:03:44'),(111,53,37,'Bolinha de queijo',16,1.00,NULL,'2026-06-06 20:22:13'),(112,54,37,'Bolinha de queijo',1,1.00,NULL,'2026-06-07 12:29:14'),(113,54,28,'Combo Lanche',2,18.00,NULL,'2026-06-07 12:29:14'),(114,55,30,'Coxinha de frango',1,7.00,NULL,'2026-06-08 23:42:05'),(115,55,34,'Mini pizza de calabresa',1,11.00,NULL,'2026-06-08 23:42:05'),(116,56,29,'Marmita do Dia',1,41.00,'{\"tamanho\":\"G\",\"carbo\":\"Macarrão\",\"carbos\":[\"Macarrão\"],\"proteinas\":[\"Carne de boi\",\"Carne de boi desfiada\"],\"saladas\":[\"Alface\",\"Tomate\"],\"adicionais\":[\"Ovo\",\"Batata frita\"],\"valor_base\":26,\"valor_extras\":15,\"valor_total\":41,\"extras_por_categoria\":{\"carbo\":{\"nome\":\"Carboidrato\",\"quantidadeSelecionada\":1,\"quantidadeInclusa\":1,\"valorExtraPorItem\":3,\"valorExtra\":0},\"proteinas\":{\"nome\":\"Proteinas\",\"quantidadeSelecionada\":2,\"quantidadeInclusa\":1,\"valorExtraPorItem\":5,\"valorExtra\":5},\"saladas\":{\"nome\":\"Saladas\",\"quantidadeSelecionada\":2,\"quantidadeInclusa\":1,\"valorExtraPorItem\":2,\"valorExtra\":2},\"adicionais\":{\"nome\":\"Adicionais\",\"quantidadeSelecionada\":2,\"quantidadeInclusa\":0,\"valorExtraPorItem\":4,\"valorExtra\":8}}}','2026-06-08 23:42:28');
/*!40000 ALTER TABLE `pedido_itens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedidos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) DEFAULT NULL,
  `data_pedido` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('pendente','preparando','pronto','finalizado','cancelado') DEFAULT 'pendente',
  `valor_total` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `idx_pedidos_usuario` (`usuario_id`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,3,'2026-05-26 18:06:42','finalizado',31.50),(2,3,'2026-05-26 18:16:33','finalizado',36.50),(3,10,'2026-05-26 18:50:01','finalizado',9.50),(4,12,'2026-05-26 19:29:10','finalizado',660.00),(5,14,'2026-05-26 19:40:15','finalizado',18.50),(6,14,'2026-05-26 19:41:18','finalizado',9.00),(9,15,'2026-05-27 00:22:08','finalizado',19.00),(10,15,'2026-05-27 00:22:27','finalizado',9.50),(11,3,'2026-05-27 01:52:19','finalizado',17.00),(12,3,'2026-05-27 01:52:24','finalizado',13.99),(13,18,'2026-05-27 12:58:21','finalizado',28.00),(14,19,'2026-05-27 13:30:04','finalizado',71.49),(15,20,'2026-05-27 13:36:11','finalizado',28.50),(20,3,'2026-05-27 17:06:02','finalizado',21.50),(21,23,'2026-05-27 17:17:14','finalizado',9.50),(22,23,'2026-05-27 17:17:26','finalizado',9.50),(23,3,'2026-05-27 17:19:49','finalizado',43.50),(25,3,'2026-05-27 17:33:24','finalizado',23.50),(29,3,'2026-05-27 18:20:50','finalizado',25.99),(30,3,'2026-05-27 18:22:11','finalizado',19.00),(31,3,'2026-05-27 18:32:28','finalizado',26.50),(32,3,'2026-05-27 18:32:39','finalizado',18.50),(35,3,'2026-05-27 20:03:26','finalizado',18.00),(36,3,'2026-05-27 20:03:47','finalizado',11.50),(37,13,'2026-05-27 20:24:15','finalizado',25.00),(38,12,'2026-05-27 20:43:26','finalizado',142.50),(39,3,'2026-05-27 21:14:43','finalizado',66.49),(40,29,'2026-05-27 21:56:56','finalizado',19.00),(41,3,'2026-05-28 19:26:10','finalizado',17.50),(42,12,'2026-05-28 19:36:38','finalizado',167.49),(43,13,'2026-05-28 20:03:46','finalizado',58.96),(44,3,'2026-05-28 22:37:30','finalizado',16.00),(45,3,'2026-06-02 11:02:45','finalizado',35.00),(46,3,'2026-06-02 11:17:52','finalizado',53.00),(47,3,'2026-06-02 11:48:34','finalizado',21.00),(48,3,'2026-06-03 13:56:34','finalizado',43.00),(49,3,'2026-06-03 14:17:09','cancelado',16.00),(50,3,'2026-06-06 16:58:08','cancelado',16.00),(51,3,'2026-06-06 19:39:39','cancelado',33.00),(52,3,'2026-06-06 20:03:44','cancelado',33.00),(53,3,'2026-06-06 20:22:13','finalizado',16.00),(54,3,'2026-06-07 12:29:14','pendente',37.00),(55,3,'2026-06-08 23:42:05','pendente',18.00),(56,3,'2026-06-08 23:42:28','cancelado',41.00);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_agendados`
--

DROP TABLE IF EXISTS `pedidos_agendados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedidos_agendados` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` int(11) NOT NULL,
  `produto_nome` varchar(120) NOT NULL,
  `descricao` text DEFAULT NULL,
  `data_agendada` datetime NOT NULL,
  `valor_total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `status` enum('agendado','concluido','cancelado') NOT NULL DEFAULT 'agendado',
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_pedidos_agendados_usuario` (`usuario_id`),
  KEY `idx_pedidos_agendados_status` (`status`),
  KEY `idx_pedidos_agendados_data` (`data_agendada`),
  CONSTRAINT `fk_pedidos_agendados_usuario` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_agendados`
--

LOCK TABLES `pedidos_agendados` WRITE;
/*!40000 ALTER TABLE `pedidos_agendados` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos_agendados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `produtos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `categoria` varchar(50) NOT NULL DEFAULT 'produtos',
  `descricao` text DEFAULT NULL,
  `imagem` longtext DEFAULT NULL,
  `is_marmita` tinyint(1) NOT NULL DEFAULT 0,
  `marmita_config` longtext DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT 1,
  `preco` decimal(10,2) NOT NULL,
  `disponibilidade` tinyint(1) DEFAULT 1,
  `categoria_id` int(11) DEFAULT NULL,
  `criado_em` timestamp NOT NULL DEFAULT current_timestamp(),
  `atualizado_em` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `categoria_id` (`categoria_id`),
  KEY `idx_produtos_categoria` (`categoria`),
  KEY `idx_produtos_ativo` (`ativo`),
  CONSTRAINT `produtos_ibfk_1` FOREIGN KEY (`categoria_id`) REFERENCES `categorias` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (9,'Pastel','salgados','Pastel de carne','https://imgs.search.brave.com/u5v40LY5GfOPWj1draJVVy0jeUq5dz5Psfh-xMecz40/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzA0LzQ1LzIwLzM1/LzM2MF9GXzQ0NTIw/MzU5MV9tT2dhck9P/VTZUOHFyd01BcUNj/UFE0a2RjSHNQdlFn/Ui5qcGc',0,NULL,0,9.50,1,NULL,'2026-05-26 18:49:35','2026-06-06 18:18:01'),(10,'Pastel','salgados','Pastel de frango','https://imgs.search.brave.com/u5v40LY5GfOPWj1draJVVy0jeUq5dz5Psfh-xMecz40/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzA0LzQ1LzIwLzM1/LzM2MF9GXzQ0NTIw/MzU5MV9tT2dhck9P/VTZUOHFyd01BcUNj/UFE0a2RjSHNQdlFn/Ui5qcGc',0,NULL,0,9.49,1,NULL,'2026-05-26 18:52:46','2026-06-06 18:18:03'),(11,'Pastel','salgados','Pastel de pizza','https://imgs.search.brave.com/u5v40LY5GfOPWj1draJVVy0jeUq5dz5Psfh-xMecz40/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzA0LzQ1LzIwLzM1/LzM2MF9GXzQ0NTIw/MzU5MV9tT2dhck9P/VTZUOHFyd01BcUNj/UFE0a2RjSHNQdlFn/Ui5qcGc',0,NULL,0,9.50,1,NULL,'2026-05-26 18:53:22','2026-06-06 18:18:06'),(12,'Coxinha','salgados','Coxinha de frango','https://imgs.search.brave.com/SiyxhaCWkq7T2w9PgB1d0xmijUS-BEkYB4YGkLn1KXs/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTMy/NzYxNzQyNy9waG90/by9mcmllZC1jb3hp/bmhhLW9uLXdvb2Rl/bi1ib2FyZC13aXRo/LXllbGxvdy1iYWNr/Z3JvdW5kLmpwZz9z/PTYxMng2MTImdz0w/Jms9MjAmYz1YT1lx/S21sZW9xU1JhTGdP/Nnh4enB2d29uWW1C/WVFEa2FVV2JaWV9H/MnNNPQ',0,NULL,0,9.00,1,NULL,'2026-05-26 18:53:56','2026-06-06 18:17:59'),(13,'Chá Matte Leão','refrigerantes','Chá Matte Leão','https://imgs.search.brave.com/92dwsccuTcq8jWkdRxkan-2wK3TZFFKeKfHo-B9e9yk/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jYXJy/ZWZvdXJicmZvb2Qu/dnRleGFzc2V0cy5j/b20vYXJxdWl2b3Mv/aWRzLzE4OTAyMTI5/L2NoYS1tYXRlLW9y/aWdpbmFsLW1hdHRl/LWxlYW8tZ2FycmFm/YS00NTBtbC0xLmpw/Zz92PTYzNzU5MDE5/MzQ5NTY3MDAwMA',0,NULL,0,4.50,1,NULL,'2026-05-26 18:55:46','2026-06-06 18:17:54'),(14,'Coca-cola 600ml','refrigerantes','Coca-cola 600ml','https://imgs.search.brave.com/ZzWP9iwksmbNPDjs9_aA7HczHfEWvEr_3Ghmv1poOgU/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tYXJt/b3JlaW8uY29tLmJy/L3dwLWNvbnRlbnQv/dXBsb2Fkcy8yMDIw/LzA1L2NvY2EtY29s/YS02MDAtbWwtMS0z/MDB4MzAwLmpwZw',0,NULL,0,7.50,1,NULL,'2026-05-26 18:56:25','2026-06-06 18:17:56'),(15,'Pastel','salgados','','https://imgs.search.brave.com/SiyxhaCWkq7T2w9PgB1d0xmijUS-BEkYB4YGkLn1KXs/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9tZWRp/YS5pc3RvY2twaG90/by5jb20vaWQvMTMy/NzYxNzQyNy9waG90/by9mcmllZC1jb3hp/bmhhLW9uLXdvb2Rl/bi1ib2FyZC13aXRo/LXllbGxvdy1iYWNr/Z3JvdW5kLmpwZz9z/PTYxMng2MTImdz0w/Jms9MjAmYz1YT1lx/S21sZW9xU1JhTGdP/Nnh4enB2d29uWW1C/WVFEa2FVV2JaWV9H/MnNNPQ',0,NULL,0,9.50,1,NULL,'2026-05-26 18:57:05','2026-05-26 18:57:27'),(16,'Marmita do Ratão','marmitas','Marmita Braba','https://imgs.search.brave.com/TAVuP_5DpJ5RLfuOtzBYr_PFt-LNllJh7jCTAzG6DVc/rs:fit:500:0:1:0/g:ce/aHR0cDovL3d3dy5j/YXNhcmVkby5jb20v/YmxvZy93cC1jb250/ZW50L3VwbG9hZHMv/MjAxOS8wOC9tb250/YXItbWFybWl0YS5q/cGc',1,'{\"precoP\":19,\"precoM\":25,\"precoG\":28,\"carbos\":[\"Arroz\",\"Macarrão\"],\"proteinas\":[\"Carne de cordeiro Suiço\",\"Carne de Boi Litorâneo\",\"Carne de porco limpo\",\"Frango maromba\"],\"saladas\":[\"Alface\",\"Tomate\",\"Pepino\"],\"adicionais\":[\"Batata-frita\",\"Farofa\",\"Banana\"],\"extraCarbo\":2,\"extraProteina\":5,\"extraSalada\":2,\"extraAdicional\":1.5}',0,19.00,1,NULL,'2026-05-26 19:01:47','2026-06-06 18:17:49'),(17,'Pastel','salgados','Pastel de Palmito','https://imgs.search.brave.com/u5v40LY5GfOPWj1draJVVy0jeUq5dz5Psfh-xMecz40/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzA0LzQ1LzIwLzM1/LzM2MF9GXzQ0NTIw/MzU5MV9tT2dhck9P/VTZUOHFyd01BcUNj/UFE0a2RjSHNQdlFn/Ui5qcGc',0,NULL,0,9.50,1,NULL,'2026-05-26 19:27:14','2026-06-06 18:18:08'),(18,'CODEx TESTE PRODUTO','produtos','Produto de teste automatizado','',0,NULL,0,9.50,1,NULL,'2026-05-27 00:22:02','2026-05-27 01:49:59'),(19,'Bolacha','produtos','trakina','https://imgs.search.brave.com/GmJwI45Urm8aN12Pc4omj6OcVh6H_oRz0TPZPjZOwW8/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9odHRw/Mi5tbHN0YXRpYy5j/b20vRF9RX05QXzJY/XzgxMjk1OS1NTEI2/OTk0MzYwODEwMF8w/NjIwMjMtRS53ZWJw',0,NULL,0,4.00,1,NULL,'2026-05-27 19:21:11','2026-06-06 18:17:51'),(20,'Sem nome','salgados','','',0,NULL,0,0.00,1,NULL,'2026-06-06 17:06:53','2026-06-06 17:06:58'),(21,'Pastel e Suco','combos','Pastel\nsuco','',0,NULL,0,12.00,1,NULL,'2026-06-06 18:05:35','2026-06-06 18:17:46'),(22,'Coca-Cola zero','refrigerantes','Coca-Cola 350ml','https://imgs.search.brave.com/xsTi7GoEU16l9FXrwpAe-8snThsPKxc1EpK-SaRAsM0/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pbWFn/ZXMudGNkbi5jb20u/YnIvaW1nL2ltZ19w/cm9kLzg1ODc2NC9y/ZWZyaWdlcmFudGVf/Y29jYV9jb2xhX3pl/cm9fbGF0YV8zNTBt/bF9jXzEyXzM2NV8x/XzIwMjAxMDIxMTUy/NTEzLmpwZw',0,NULL,1,6.50,1,NULL,'2026-06-06 18:54:12','2026-06-06 18:54:45'),(23,'Coca-Cola zero','refrigerantes','Coca-Cola 600ml','https://imgs.search.brave.com/zyvPiaEY-ongVhZlDkK5FXj7dA82y7-AVssXYVB0F6s/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pLnpz/dC5jb20uYnIvdGh1/bWJzLzUxL2UvMTEv/LTE0OTIyMTk4OTQu/anBn',0,NULL,1,11.00,1,NULL,'2026-06-06 18:56:18','2026-06-06 18:56:18'),(24,'GUARANA ANTARCTICA LATA 350 ML','refrigerantes','GUARANA ANTARCTICA LATA 350 ML','https://imgs.search.brave.com/2fY4UcV2O-zvNR_MsQhXFmNI-92T5pQB-vIwk9rfPZA/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9kcGFw/YWdheW8uY29tL3dw/LWNvbnRlbnQvdXBs/b2Fkcy8yMDIzLzA5/L0dVQVJBTkEtQU5U/QVJUSUNBLUxBVEEt/MzUwLmpwZw',0,NULL,1,4.50,1,NULL,'2026-06-06 18:57:20','2026-06-06 18:57:20'),(25,'GUARANA ANTARCTICA ORIG 600 ML','refrigerantes','GUARANA ANTARCTICA ORIG 600 ML','https://imgs.search.brave.com/DqNuyfHIcqPYAwuQwYldqcbOhejKIFKHloE3yg18sQM/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9kMjF3/aWN6YnF4aWIwNC5j/bG91ZGZyb250Lm5l/dC9DQ1I4VlZ5N3hr/UEVCRUJyVV85aTky/OXdjblU9L2ZpdC1p/bi80NTN4NDUzL2Zp/bHRlcnM6ZmlsbChG/RkZGRkYpOmJhY2tn/cm91bmRfY29sb3Io/d2hpdGUpL2h0dHBz/Oi8vcHJvZHV0b3Mt/b3N1cGVyLnMzLnNh/LWVhc3QtMS5hbWF6/b25hd3MuY29tLzkz/NGY3OGU2NmI5Yzc4/ZDBlMjg0MTc4MDUx/ZGQxOGU1NWQzNGZm/MDMvMzYwLzMwNzYy/OWNkZmEyNC0zMy53/ZWJw',0,NULL,1,9.00,1,NULL,'2026-06-06 18:57:59','2026-06-06 18:57:59'),(26,'ENERGÉTICO MONSTER ENERGY ULTRA ZERO LATA 473ML','refrigerantes','ENERGÉTICO MONSTER ENERGY ULTRA ZERO LATA 473ML','https://imgs.search.brave.com/m4jZ60dcD6ca6MLNsK29-xT1A2us4bEpMkf85idKZ0E/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWFn/ZXMudGNkbi5jb20u/YnIvaW1nL2ltZ19w/cm9kLzg1ODc2NC9l/bmVyZ2V0aWNvX21v/bnN0ZXJfZW5lcmd5/X3VsdHJhX3plcm9f/bGF0YV80NzNtbF9j/XzA2Xzk5N18xX2U3/Y2Q4ODg4M2JjOTdk/MzQ3ZjMyNzRlMTlk/YTYwMWRmLmpwZw',0,NULL,1,12.50,1,NULL,'2026-06-06 18:58:46','2026-06-06 18:58:46'),(27,'Energético Monster Ultra Fiesta Mango Zero Açúcar 473ml','refrigerantes','Energético Monster Ultra Fiesta Mango Zero Açúcar 473ml','https://imgs.search.brave.com/g7O74YQ2b0gsLFdMvSIDEigjqgtXVp_Gc4juUf5C7-4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9hLXN0/YXRpYy5tbGNkbi5j/b20uYnIvMjgweDIx/MC9lbmVyZ2V0aWNv/LW1vbnN0ZXItdWx0/cmEtZmllc3RhLW1h/bmdvLXplcm8tYWN1/Y2FyLTQ3M21sLW1v/bnN0ZXItZW5lcmd5/L2Ryb2dhcmlhYXJh/dWpvc2EvMTA1ODE0/Mi81MWFmNThlMDNi/NjBjOGNjMGVmZGEy/MDU4ODVjODY1OS5q/cGVn',0,NULL,1,12.50,1,NULL,'2026-06-06 18:59:16','2026-06-06 18:59:16'),(28,'Combo Lanche','combos','2 Pasteis\n1 Coca-cola 350ml','https://imgs.search.brave.com/XMKP_ibVms7pkNPR0EZ5qo7qIH5MxLes58_WRJISWeU/rs:fit:0:180:1:0/g:ce/aHR0cHM6Ly9maWxl/czIucGVkaWRvczEw/LmNvbS5ici9leHRy/YW5ldC9hcnF1aXZv/cy9pbWFnZW5zL2Nh/cmRhcGlvMi9taW5p/L2ZkYjEzZmUxMDQz/NjcyOTMyYTMyZjdk/OGNlMjMyZWUwLmpw/Zw',0,NULL,1,18.00,1,NULL,'2026-06-06 19:01:16','2026-06-06 19:01:16'),(29,'Marmita do Dia','marmitas','Marmita do dia','https://imgs.search.brave.com/Fg3GLIqEVQsOHCbB__Hxv617J-_R_At8pYdaxdnv2rc/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93d3cu/bm9ubmFmaXQuY29t/LmJyL3dwLWNvbnRl/bnQvdGhlbWVzL25v/bm5hZml0L2ltYWdl/cy9tZW51LWZyYW5n/b3MuanBn',1,'{\"precoP\":15,\"precoM\":22,\"precoG\":26,\"carbos\":[\"Macarrão\"],\"proteinas\":[\"Carne de boi\",\"Carne de boi desfiada\",\"Peito de frango\",\"Peixe\"],\"saladas\":[\"Alface\",\"Tomate\"],\"adicionais\":[\"Ovo\",\"Batata frita\"]}',1,15.00,1,NULL,'2026-06-06 19:04:53','2026-06-06 19:04:53'),(30,'Coxinha de frango','salgados','Coxinha de frango','https://imgs.search.brave.com/sVWfEgpIZB--8np0DH16kTVvouNhCkZaUr-bwM7zMiE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90My5m/dGNkbi5uZXQvanBn/LzA0LzA3LzU3LzYy/LzM2MF9GXzQwNzU3/NjI3Nl9lWDlRMEg0/ZE52b2pCU0hmb0Vu/Z1Y2V3BtOTQwcmRY/TC5qcGc',0,NULL,1,7.00,1,NULL,'2026-06-06 19:07:03','2026-06-06 19:07:03'),(31,'Pastel de carne','salgados','Pastel de carne','https://imgs.search.brave.com/ZbK4AjWovXa9Kde3JncjQbQUrlCZf0hP-xAk9Xh8PFg/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/Zm90b3MtcHJlbWl1/bS9wb3JjYW8tZGUt/cGFzdGEtZnJpdGEt/bmEtbWVzYS1wYXN0/ZWxhcmlhLWRlLWNh/cm5lXzQzNDE5My01/NTguanBnP3NlbXQ9/YWlzX2h5YnJpZCZ3/PTc0MCZxPTgw',0,NULL,1,9.00,1,NULL,'2026-06-06 19:09:39','2026-06-06 19:09:39'),(32,'Pastel de frango','salgados','Pastel de frango','https://imgs.search.brave.com/FhwzdmSjqihYzJhYbbHteXE8qV2vevLdjSkS21KLpzU/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pbWFn/ZW5zLmpvdGFqYS5j/b20vcHJvZHV0b3Mv/MzIzNS83RjFCRDYy/OTVCM0RCMUU5NzA0/RkI2MDRFQUE4NDhC/NUU1NjVDMjRGNzAx/RDQ3NjJBNDYzNEEz/QkZDOEIzQzM2Lmpw/ZWc',0,NULL,1,9.00,1,NULL,'2026-06-06 19:10:17','2026-06-06 19:10:17'),(33,'Pastel de pizza','salgados','Pastel de pizza','https://imgs.search.brave.com/Hk6Uoj2jZ9xqpefrJk2kjnH258TUtPl2NHTDCkJOBSY/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9yZWNl/aXRlcmFwaWEuY29t/LmJyL3dwLWNvbnRl/bnQvdXBsb2Fkcy8y/MDIyLzA2L2NvbW8t/ZmF6ZXItcGFzdGVs/LWRlLXBpenphLmpw/Zw',0,NULL,1,9.00,1,NULL,'2026-06-06 19:10:47','2026-06-06 19:10:47'),(34,'Mini pizza de calabresa','salgados','Mini pizza de calabresa','https://imgs.search.brave.com/btW_KrO9B8GcLCL0acx8TgvnL0XZ8BEr4Z8Sf1rTKUs/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9hY2Fy/bmVxdWVvbXVuZG9w/cmVmZXJlLmNvbS5i/ci91cGxvYWRzL21l/ZGlhL2ltYWdlLzMz/LTExLTI0LnBuZw',0,NULL,1,11.00,1,NULL,'2026-06-06 19:11:31','2026-06-06 19:11:31'),(35,'Mini pizza de frango','salgados','Mini pizza de frango','https://imgs.search.brave.com/MBTtwXZntOamz1KFLcDY-9ZsIqtjFLl0MKsYy7u8pSE/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jZG4u/b2NlYW5zZXJ2ZXIu/Y29tLmJyL2xvamFz/L2NpYWRhdG9ydGEv/dXBsb2Fkc19wcm9k/dXRvL3BpenphLWZy/YW5nby10LXAtNjY5/NTU4NGE3NjI0My5q/cGc',0,NULL,1,11.00,1,NULL,'2026-06-06 19:12:09','2026-06-06 19:12:09'),(36,'Mini pizza de carne','salgados','Mini pizza de carne','https://imgs.search.brave.com/bA6KsWmQxBQWlky1xRWzY0tyOZhkZMQ_SzCnKVAExvI/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9pbWcu/ZnJlZXBpay5jb20v/Zm90b3MtcHJlbWl1/bS9waXp6YS1jYXJu/ZS1mcmFuZ28tcGVw/ZXJvbmktcXVlaWpv/LWNoaWxsaS1jYXBz/aWN1bS1jZWJvbGEt/YXplaXRvbmEtbmEt/cGxhY2EtZGUtbWFk/ZWlyYV83NjQ0MTEt/MjE0My5qcGc_c2Vt/dD1haXNfaHlicmlk',0,NULL,1,11.00,1,NULL,'2026-06-06 19:12:52','2026-06-06 19:12:52'),(37,'Bolinha de queijo','salgados','Bolinha de queijo','https://imgs.search.brave.com/jtPiX-8HzJqdlaC3-9mfIm0eb3u2y6liU0xH_ARwU9E/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jb21p/ZGluaGFzZG9jaGVm/LmNvbS93cC1jb250/ZW50L3VwbG9hZHMv/MjAxOC8xMC9Cb2xp/bmhhLWRlLVF1ZWlq/by1GJUMzJUExY2ls/LmpwZw',0,NULL,1,1.00,1,NULL,'2026-06-06 19:13:47','2026-06-06 19:13:47'),(38,'Salsicha empanada','salgados','Salsicha empanada','https://imgs.search.brave.com/aRt1f1k4mQQqgAM9JINoYtSSJnZfrWjOVtz-WCqFTWg/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9nZXJh/ZG9ycmVjZWl0YXMu/Y29tLmJyL2FwaS9w/aG90by9yZWNpcGVz/L3NhbHNpY2hhLWVt/cGFuYWRhLWNhc2Vp/cmEtMTc1MjQzMjE1/OTgzOA',0,NULL,1,7.00,1,NULL,'2026-06-06 19:14:20','2026-06-06 19:14:20'),(39,'Bolacha Recheada Trakinas','produtos','Bolacha Recheada Trakinas','https://imgs.search.brave.com/VEqZIFfNqTs-_ima-1askS7CSBf6iQnyfG-cu_4FB3Y/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9odHRw/Mi5tbHN0YXRpYy5j/b20vRF9OUV9OUF84/Njg1MTEtTUxBODI5/NTIzNTA5NzNfMDMy/MDI1LU8ud2VicA',0,NULL,1,4.00,1,NULL,'2026-06-06 19:15:47','2026-06-06 19:15:47'),(40,'Biscoito Oreo','produtos','Biscoito Oreo','https://imgs.search.brave.com/-YnWXhBR80qX6SpiJGM271E0ivx6-MnNY3IjaomGY1Y/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9jZG4u/YXdzbGkuY29tLmJy/LzYwMHg3MDAvMTAz/MC8xMDMwNjc1L3By/b2R1dG8vMTgyMDUw/MDM2NTgxODg0MmVk/Ny5qcGc',0,NULL,1,5.00,1,NULL,'2026-06-06 19:16:13','2026-06-06 19:19:05'),(41,'SNICKERS BRANCO','produtos','SNICKERS BRANCO','https://imgs.search.brave.com/MhbA1Z_cULml6OJdLjBURwKja1VFuMau3U1oft7rK4k/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9zdG9x/dWUuYWdpbGVjZG4u/Y29tLmJyLzEzMTQ2/LmpwZz92PTM3LTE2/NTIwNzkyMDg',0,NULL,1,4.50,1,NULL,'2026-06-06 19:16:41','2026-06-06 19:17:21'),(42,'Snickers Chocolate','produtos','Snickers Chocolate','https://imgs.search.brave.com/meYnCzhgTQUIKoNxWspeM9ASp7zpT5-sEmP9dbrZth4/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly9zdDUu/ZGVwb3NpdHBob3Rv/cy5jb20vMjYyMzUx/NjIvNjUzNzUvaS80/NTAvZGVwb3NpdHBo/b3Rvc182NTM3NTE0/NTYtc3RvY2stcGhv/dG8tY2xvc2Utdmll/dy1zbmlja2Vycy1j/aG9jb2xhdGUtYmFy/cy5qcGc',0,NULL,1,4.50,1,NULL,'2026-06-06 19:17:46','2026-06-06 19:18:29'),(43,'Kit Kat','produtos','Kit Kat','https://imgs.search.brave.com/HHmV3LxF6cdIR2G6IrWFlZo_bXXvvoaR2L-qOAFArOk/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly90My5m/dGNkbi5uZXQvanBn/LzA3LzA4LzA2LzA2/LzM2MF9GXzcwODA2/MDY1MV96akRORVJJ/NGhRdjc3a1JuR3dz/TzJUS3NZSm9zYndL/Mi5qcGc',0,NULL,1,5.00,1,NULL,'2026-06-06 19:18:47','2026-06-06 19:18:47'),(44,'Pastel','salgados','','',0,NULL,0,2.00,1,NULL,'2026-06-08 23:50:48','2026-06-08 23:50:54');
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(120) NOT NULL,
  `email` varchar(190) NOT NULL,
  `login` varchar(40) DEFAULT NULL,
  `nick` varchar(60) DEFAULT NULL,
  `senha` varchar(255) NOT NULL,
  `tipo` enum('aluno','funcionario','admin','cliente') NOT NULL DEFAULT 'cliente',
  `data_nascimento` date DEFAULT NULL,
  `sexo` enum('masculino','feminino','outro','nao_informado') DEFAULT NULL,
  `endereco` varchar(255) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `descricao` text DEFAULT NULL,
  `data_cadastro` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_usuarios_login` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (3,'Administrador','admin@cantina.local','','Vieira','$2y$10$N1gjtDglWTZ2VI70kqH7uuoo7xvZueEXg5N/EK2SD0wExAlYh501G','admin',NULL,'','','imagens/perfis/perfil_3_20260527231529_bf3db25b.jpg','','2026-05-26 18:00:22'),(10,'Vitor','vitor2@gmail',NULL,NULL,'$2y$10$iqx5Mfc4HqpSf7UimzcD0urpMUQv3JsJ9IP9kpnY4Zaec0Yn.a3Ca','cliente',NULL,NULL,NULL,NULL,NULL,'2026-05-26 18:38:26'),(12,'Muni','muni@gmail.com',NULL,NULL,'$2y$10$OlBMa7IKBp7s.NhNUbBTx.7KsmyHze/zNczJSg9sr0FcHPOq5UTmG','cliente',NULL,NULL,NULL,'imagens/perfis/perfil_12_20260527225021_f8e626a0.jpg',NULL,'2026-05-26 19:25:31'),(13,'Vitor','vieira@gmail.com',NULL,NULL,'$2y$10$I6kq5Lp.sDT1Fxo4v3ZyV.Kk3udgHjzkehvEvb9yW6iBptUnkPz.u','cliente',NULL,NULL,NULL,'imagens/perfis/perfil_13_20260527222357_9d5c458e.jpg',NULL,'2026-05-26 19:33:20'),(14,'Leticia','leticia.amomo@gmail.com',NULL,NULL,'$2y$10$/hPw2Dt9IJx/H8OhJLKtcOyql4.mbp8nJUKKi09tLi9SCi8S3Lt5K','cliente',NULL,NULL,NULL,NULL,NULL,'2026-05-26 19:39:47'),(15,'Gabriel','gabrielandradepeixer@gmail.com',NULL,NULL,'$2y$10$HHV1yM/QW5OzM1i6zaBZH.dZjOMPWv0P1pFaF2mgsUZozQORgAwbG','cliente',NULL,NULL,NULL,NULL,NULL,'2026-05-27 00:21:26'),(18,'leticia','leticia@gmail',NULL,NULL,'$2y$10$g53PkpLRIfTpsKPvYPNr5eULxndPj0LK0zjInV8npC.3ibuy3Hndq','cliente',NULL,NULL,NULL,NULL,NULL,'2026-05-27 12:57:15'),(19,'Vitor','vitorhugo@gmail.com',NULL,NULL,'$2y$10$nTbTc6bPGV75WTFrjsaFn.JCubXWLzF/J61MlWY4/w8MTkL9cw/Ni','cliente',NULL,NULL,NULL,NULL,NULL,'2026-05-27 13:28:34'),(20,'Fer','ferzin@gmail.com',NULL,NULL,'$2y$10$xaliLO2LAmVxkZznqhc3M.7FzxkyvWxZbMPJvwMygv6y4oFV2ZnIS','cliente',NULL,NULL,NULL,NULL,NULL,'2026-05-27 13:35:31'),(23,'Print Teste','print_teste@cantina.local',NULL,NULL,'$2y$10$h3q3JYr20J4bu5941DvVf.dZ8LkXZfumuZTagoTfOwXG3uWw0/rRq','admin',NULL,NULL,NULL,NULL,NULL,'2026-05-27 17:15:57'),(29,'VITOR','vitorhugovieira3397@gmail.com','vitorhugovieira3397',NULL,'$2y$10$95FucMDLopkee7WyUWzl.e5aw9qi5d9gHSP57seMVJRK8v7M19aP.','cliente',NULL,NULL,NULL,NULL,NULL,'2026-05-27 21:56:48'),(30,'Vitor','vitor2@gmail.com','vitor2',NULL,'$2y$10$v.mO9/DdUOhdyUzRToXSIunXppCZ0Ea1Wb.7f4LDTni41R22OY77m','cliente',NULL,NULL,NULL,NULL,NULL,'2026-05-29 15:10:37'),(31,'Matheus','matheus@gmail.com','matheus',NULL,'$2y$10$GJpW4nUH8rh/TYV59IdSd.lbnXEZh1iHyKQyyuAS5xAQddtvibAEO','cliente',NULL,NULL,NULL,NULL,NULL,'2026-06-03 19:31:05'),(32,'Vieira048','vieira048@gmail.com','vieira048',NULL,'$2y$10$.6aKdh55LkbDpZYWWJt2/.h3e6FDTcWRwf5onz2DyuXEAyhwvknbC','cliente',NULL,NULL,NULL,NULL,NULL,'2026-06-06 17:35:09');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'sabores_tecnicos'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-09  8:37:17
