## 1️⃣ Création et utilisation de la base de données

```sql
CREATE DATABASE GestionStock
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;
```

```sql
USE GestionStock;
```
Création des tables (schéma)

### 🔹 Table `typeProduit`

```sql
CREATE TABLE typeProduit (
    id_type INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL
);
```

```sql
INSERT INTO typeProduit (libelle) VALUES
('alimentation'),
('périphérique'),
('matériel portable'),
('switch'),
('réseau');
```

---

### 🔹 Table `produit`

```sql
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
```

---

### 🔹 Table `user`

```sql
CREATE TABLE user (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    role VARCHAR(30) NOT NULL
);
```

```sql
INSERT INTO user (nom, role) VALUES
('Alice', 'admin'),
('Bob', 'gestionnaire'),
('Claire', 'vendeur'),
('David', 'vendeur'),
('Emma', 'lecteur');
```

---

### 🔹 Table `facture`

```sql
CREATE TABLE facture (
    id_facture INT AUTO_INCREMENT PRIMARY KEY,
    date_facture DATE NOT NULL,
    id_user INT NOT NULL,
    CONSTRAINT fk_facture_user
        FOREIGN KEY (id_user) REFERENCES user(id_user)
);
```

---

## 3️⃣ Insertion des produits (extrait)

```sql
INSERT INTO produit (nom, stock, prix, id_type) VALUES
('Riz 5kg', 50, 12.50, 1),
('Clavier USB', 20, 15.90, 2),
('PC portable Dell', 5, 799.00, 3),
('Switch Cisco 24 ports', 6, 450.00, 4),
('Routeur WiFi', 12, 99.00, 5);
```

➡️ La base contient **au minimum 4 produits par type**, conformément au sujet.

---

## 4️⃣ Requêtes SQL métier

### 🔹 Stock total par type (GROUP BY)

```sql
SELECT t.libelle, SUM(p.stock) AS stock_total
FROM produit p
JOIN typeProduit t ON p.id_type = t.id_type
GROUP BY t.libelle;
```

---

### 🔹 Valeur totale du stock (SUM)

```sql
SELECT SUM(stock * prix) AS valeur_stock
FROM produit;
```

---

### 🔹 Produit le plus cher par type

```sql
SELECT t.libelle, p.nom, p.prix
FROM produit p
JOIN typeProduit t ON p.id_type = t.id_type
WHERE (p.id_type, p.prix) IN (
    SELECT id_type, MAX(prix)
    FROM produit
    GROUP BY id_type
);
```

---

## 5️⃣ Gestion des utilisateurs et privilèges

```sql
CREATE USER 'admin_app'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE USER 'lecteur'@'localhost' IDENTIFIED BY 'Lecteur@123';
CREATE USER 'api_user'@'127.0.0.1' IDENTIFIED BY 'Api@123';
```

```sql
GRANT ALL PRIVILEGES ON GestionStock.* TO 'admin_app'@'localhost';
GRANT SELECT ON GestionStock.* TO 'lecteur'@'localhost';
GRANT SELECT, INSERT, UPDATE ON GestionStock.* TO 'api_user'@'127.0.0.1';
FLUSH PRIVILEGES;
```

---

## 6️⃣ Tests de droits

### 🔹 Test avec `lecteur` (doit échouer)

```sql
INSERT INTO produit VALUES (NULL,'Test',1,1.00,1);
```

Résultat attendu :

```
ERROR 1142 (42000): INSERT command denied
```

---

### 🔹 Test avec `api_user` (doit échouer)

```sql
ALTER TABLE produit ADD test INT;
```

Résultat attendu :

```
ERROR 1142 (42000): ALTER command denied
```

---

## 7️⃣ Sauvegarde et restauration

### 🔹 Sauvegarde

```bash
mysqldump -u root -p GestionStock > gestionstock.sql
```

### 🔹 Suppression volontaire

```sql
DROP TABLE produit;
```

### 🔹 Restauration

```bash
mysql -u root -p GestionStock < gestionstock.sql
```

---