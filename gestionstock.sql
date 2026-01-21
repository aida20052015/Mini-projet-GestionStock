-- =====================================================
-- 1) Création et utilisation de la base de données
-- =====================================================

CREATE DATABASE GestionStock
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE GestionStock;

-- =====================================================
-- 2) Création des tables
-- =====================================================

-- Table typeProduit
CREATE TABLE typeProduit (
    id_type INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL
);

INSERT INTO typeProduit (libelle) VALUES
('alimentation'),
('périphérique'),
('matériel portable'),
('switch'),
('réseau');

-- -----------------------------------------------------

-- Table produit
CREATE TABLE produit (
    id_produit INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    stock INT NOT NULL,
    prix DECIMAL(10,2) NOT NULL,
    id_type INT NOT NULL,
    CONSTRAINT fk_produit_type
        FOREIGN KEY (id_type) REFERENCES typeProduit(id_type)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- -----------------------------------------------------

-- Table user
CREATE TABLE user (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    role VARCHAR(30) NOT NULL
);

INSERT INTO user (nom, role) VALUES
('Alice', 'admin'),
('Bob', 'gestionnaire'),
('Claire', 'vendeur'),
('David', 'vendeur'),
('Emma', 'lecteur');

-- -----------------------------------------------------

-- Table facture
CREATE TABLE facture (
    id_facture INT AUTO_INCREMENT PRIMARY KEY,
    date_facture DATE NOT NULL,
    id_user INT NOT NULL,
    CONSTRAINT fk_facture_user
        FOREIGN KEY (id_user) REFERENCES user(id_user)
);

-- =====================================================
-- 3) Insertion des produits
-- =====================================================

INSERT INTO produit (nom, stock, prix, id_type) VALUES
('Riz 5kg', 50, 12.50, 1),
('Clavier USB', 20, 15.90, 2),
('PC portable Dell', 5, 799.00, 3),
('Switch Cisco 24 ports', 6, 450.00, 4),
('Routeur WiFi', 12, 99.00, 5);

-- =====================================================
-- 4) Requêtes SQL métier
-- =====================================================

-- Stock total par type
SELECT t.libelle, SUM(p.stock) AS stock_total
FROM produit p
JOIN typeProduit t ON p.id_type = t.id_type
GROUP BY t.libelle;

-- Valeur totale du stock
SELECT SUM(stock * prix) AS valeur_stock
FROM produit;

-- Produit le plus cher par type
SELECT t.libelle, p.nom, p.prix
FROM produit p
JOIN typeProduit t ON p.id_type = t.id_type
WHERE (p.id_type, p.prix) IN (
    SELECT id_type, MAX(prix)
    FROM produit
    GROUP BY id_type
);

-- =====================================================
-- 5) Gestion des utilisateurs et privilèges
-- =====================================================

CREATE USER 'admin_app'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE USER 'lecteur'@'localhost' IDENTIFIED BY 'Lecteur@123';
CREATE USER 'api_user'@'127.0.0.1' IDENTIFIED BY 'Api@123';

GRANT ALL PRIVILEGES ON GestionStock.* TO 'admin_app'@'localhost';
GRANT SELECT ON GestionStock.* TO 'lecteur'@'localhost';
GRANT SELECT, INSERT, UPDATE ON GestionStock.* TO 'api_user'@'127.0.0.1';
FLUSH PRIVILEGES;

-- =====================================================
-- 6) Tests de droits (doivent échouer selon l'utilisateur)
-- =====================================================

-- Test avec lecteur (doit échouer)
INSERT INTO produit VALUES (NULL,'Test',1,1.00,1);

-- Test avec api_user (doit échouer)
ALTER TABLE produit ADD test INT;

-- =====================================================
-- 7) Sauvegarde et restauration (commandes système)
-- =====================================================

-- Sauvegarde
mysqldump -u root -p GestionStock > gestionstock.sql

-- Suppression volontaire
DROP TABLE produit;

-- Restauration
mysql -u root -p GestionStock < gestionstock.sql
