CREATE DATABASE IF NOT EXISTS yourwayyourcar CHARACTER SET=utf8mb4 COLLATE=utf8mb4_general_ci;

USE yourwayyourcar;

CREATE TABLE IF NOT EXISTS adresse (
    num_voie INT NOT NULL,
    nom_voie VARCHAR(255) NOT NULL,
    code_postal INT NOT NULL,
    bis_ter VARCHAR(100) NOT NULL,
    ville VARCHAR(255) NOT NULL,
    pays_etat VARCHAR(100) NOT NULL,
    PRIMARY KEY (num_voie, nom_voie, code_postal)
);

CREATE TABLE IF NOT EXISTS client (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    mail VARCHAR(255) NOT NULL,
    `password` VARCHAR(255) NOT NULL,
    date_naissance DATE NOT NULL,
    date_inscription DATETIME NOT NULL DEFAULT NOW(),
    telephone VARCHAR(100) NOT NULL,
    num_voie INT NOT NULL,
    nom_voie VARCHAR(255) NOT NULL,
    code_postal INT NOT NULL,
    FOREIGN KEY (num_voie, nom_voie, code_postal) REFERENCES adresse(num_voie, nom_voie, code_postal) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS agence (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    mail VARCHAR(255) NOT NULL,
    telephone VARCHAR(100) NOT NULL,
    num_voie INT NOT NULL,
    nom_voie VARCHAR(255) NOT NULL,
    code_postal INT NOT NULL,
    FOREIGN KEY (num_voie, nom_voie, code_postal) REFERENCES adresse(num_voie, nom_voie, code_postal) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS client_auth (
    client_id INT PRIMARY KEY NOT NULL,
    compte_confirme BOOLEAN NOT NULL DEFAULT FALSE,
    tentative_password INT NOT NULL DEFAULT 0,
    code_recuperation INT
);

CREATE TABLE IF NOT EXISTS discussion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    objet VARCHAR(100) NOT NULL,
    `type` VARCHAR(100) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES client(id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `message` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    discussion_id INT NOT NULL,
    is_support_message BOOLEAN NOT NULL,
    content TEXT NOT NULL,
    FOREIGN KEY (discussion_id) REFERENCES discussion(id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS vehicule_categorie (
    categorie_code CHAR(1) PRIMARY KEY NOT NULL,
    designation VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS vehicule_type (
    type_code CHAR(1) PRIMARY KEY NOT NULL,
    designation VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS vehicule_transmission (
    transmission_code CHAR(1) PRIMARY KEY NOT NULL,
    designation VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS vehicule_fuel (
    fuel_code CHAR(1) PRIMARY KEY NOT NULL,
    designation VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS van (
    id INT AUTO_INCREMENT PRIMARY KEY,
    van_categorie_code CHAR(1) NOT NULL,
    van_type_code CHAR(1) NOT NULL,
    designation VARCHAR(100) NOT NULL,
    FOREIGN KEY (van_categorie_code) REFERENCES vehicule_categorie(categorie_code) ON UPDATE CASCADE,
    FOREIGN KEY (van_type_code) REFERENCES vehicule_type(type_code) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS marque (
    nom VARCHAR(100) PRIMARY KEY NOT NULL
);

CREATE TABLE IF NOT EXISTS model (
    nom VARCHAR(100) NOT NULL,
    marque_nom VARCHAR(100) NOT NULL,
    model_categorie_code CHAR(1) NOT NULL,
    model_type_code CHAR(1) NOT NULL,
    model_transmission_code CHAR(1) NOT NULL,
    model_fuel_code CHAR(1) NOT NULL,
    model_van_id INT,
    PRIMARY KEY (nom, marque_nom),
    FOREIGN KEY (marque_nom) REFERENCES marque(nom) ON UPDATE CASCADE,
    FOREIGN KEY (model_categorie_code) REFERENCES vehicule_categorie(categorie_code) ON UPDATE CASCADE,
    FOREIGN KEY (model_type_code) REFERENCES vehicule_type(type_code) ON UPDATE CASCADE,
    FOREIGN KEY (model_transmission_code) REFERENCES vehicule_transmission(transmission_code) ON UPDATE CASCADE,
    FOREIGN KEY (model_fuel_code) REFERENCES vehicule_fuel(fuel_code) ON UPDATE CASCADE,
    FOREIGN KEY (model_van_id) REFERENCES van(id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS vehicule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    immatriculation VARCHAR(100) UNIQUE,
    agence_id INT,
    model_nom VARCHAR(100) NOT NULL,
    marque_nom VARCHAR(100) NOT NULL,
    FOREIGN KEY (agence_id) REFERENCES agence(id) ON UPDATE CASCADE,
    FOREIGN KEY (model_nom, marque_nom) REFERENCES model(nom, marque_nom) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS tarif (
    id INT AUTO_INCREMENT PRIMARY KEY,
    prix_ht DECIMAL NOT NULL,
    montant_tva DECIMAL NOT NULL,
    prix_ttc DECIMAL NOT NULL
);

CREATE TABLE IF NOT EXISTS `location` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vehicule_id INT NOT NULL,
    agence_depart_id INT NOT NULL,
    agence_arrivee_id INT NOT NULL,
    date_prise_reservation DATETIME NOT NULL,
    date_depart DATETIME NOT NULL,
    date_arrivee DATETIME NOT NULL,
    tarif_id INT NOT NULL,
    FOREIGN KEY(vehicule_id) REFERENCES vehicule(id) ON UPDATE CASCADE,
    FOREIGN KEY(agence_depart_id) REFERENCES agence(id) ON UPDATE CASCADE,
    FOREIGN KEY(agence_arrivee_id) REFERENCES agence(id) ON UPDATE CASCADE,
    FOREIGN KEY(tarif_id) REFERENCES tarif(id) ON UPDATE CASCADE
);

INSERT INTO vehicule_categorie (categorie_code, designation) VALUES
    ('M', 'Mini'),
    ('N', 'Mini Elite'),
    ('E', 'Economy'),
    ('H', 'Economy Elite'),
    ('C', 'Compact'),
    ('D', 'Compact Elite'),
    ('I', 'Intermediate'),
    ('J', 'Intermediate Elite'),
    ('S', 'Standard'),
    ('R', 'Standard Elite'),
    ('F', 'Fullsize'),
    ('G', 'Fullsize Elite'),
    ('P', 'Premium'),
    ('U', 'Premium Elite'),
    ('L', 'Luxury'),
    ('W', 'Luxury Elite'),
    ('O', 'Oversize'),
    ('X', 'Special');

INSERT INTO vehicule_type (type_code, designation) VALUES
    ('B', '2-3 Door'),
    ('C', '2/4 Door'),
    ('D', '4-5 Door'),
    ('W', 'Wagon/Estate'),
    ('V', 'Passenger Van'),
    ('L', 'Limousine/Sedan'),
    ('S', 'Sport'),
    ('T', 'Convertible'),
    ('F', 'SUV'),
    ('J', 'Open Air All Terrain'),
    ('X', 'Special'),
    ('P', 'Pick up (single/extended cab) 2 door'),
    ('Q', 'Pick up (double cab) 4 door'),
    ('Z', 'Special Offer Car'),
    ('E', 'Coupe'),
    ('M', 'Monospace'),
    ('R', 'Recreational Vehicle'),
    ('H', 'Motor Home'),
    ('Y', '2 Wheel Vehicule'),
    ('N', 'Roadster'),
    ('G', 'Crossover'),
    ('K', 'Commercial Van/Truck');

INSERT INTO vehicule_transmission (transmission_code, designation) VALUES
    ('M', 'Manual Unspecified Drive'),
    ('N', 'Manual 4WD'),
    ('C', 'Manual AWD'),
    ('A', 'Auto Unspecified Drive'),
    ('B', 'Auto 4WD'),
    ('D', 'Auto AWD');

INSERT INTO vehicule_fuel (fuel_code, designation) VALUES
    ('R', 'Unspecified Fuel/Power With Air'),
    ('N', 'Unspecified Fuel/Power Without Air'),
    ('D', 'Diesel Air'),
    ('Q', 'Diesel No Air'),
    ('H', 'Hybrid'),
    ('I', 'Hybrid Plug in'),
    ('E', 'Electric'),
    ('C', 'Electric'),
    ('L', 'LPG/Compressed Gas Air'),
    ('S', 'LPG/Compressed Gas No Air'),
    ('A', 'Hydrogen Air'),
    ('B', 'Hydrogen No Air'),
    ('M', 'Multi Fuel/Power Air'),
    ('F', 'Multi fuel/power No Air'),
    ('V', 'Petrol Air'),
    ('Z', 'Petrol No Air'),
    ('U', 'Ethanol Air'),
    ('X', 'Ethanol No Air');

    INSERT INTO van (van_categorie_code, van_type_code, designation) VALUES
    ('I', 'V', '6+ Seats'),
    ('J', 'V', 'Elite 6+ Seats or 5+2 Seats (2 fold down seats)'),
    ('S', 'V', '7+ seats'),
    ('R', 'V', 'Elite 7+ Seats'),
    ('F', 'V', '7+ Seats, plus more space'),
    ('G', 'V', 'Elite 7+ Seats plus more space'),
    ('P', 'V', '8+ Seats'),
    ('U', 'V', 'Elite 8+ Seats'),
    ('L', 'V', '9+ Seats'),
    ('W', 'V', 'Elite 9+ Seats'),
    ('X', 'V', '12+ Seats'),
    ('O', 'V', '15+ Seats');

    -- Insertion du premier client
INSERT INTO adresse (num_voie, nom_voie, code_postal, bis_ter, ville, pays_etat) VALUES
    (123, 'Rue de la Liberté', 75001, '', 'Paris', 'France');

INSERT INTO client (nom, prenom, mail, `password`, date_naissance, telephone, num_voie, nom_voie, code_postal) VALUES
    ('Dupont', 'Jean', 'jean.dupont@example.com', 'motdepasse1', '1990-05-15', '0123456789', 123, 'Rue de la Liberté', 75001);

INSERT INTO client_auth (client_id, compte_confirme, tentative_password, code_recuperation) VALUES
    (LAST_INSERT_ID(), TRUE, 0, NULL);

-- Insertion du deuxième client
INSERT INTO adresse (num_voie, nom_voie, code_postal, bis_ter, ville, pays_etat) VALUES
    (456, 'Avenue des Champs-Élysées', 75008, '', 'Paris', 'France');

INSERT INTO client (nom, prenom, mail, `password`, date_naissance, telephone, num_voie, nom_voie, code_postal) VALUES
    ('Durand', 'Marie', 'marie.durand@example.com', 'motdepasse2', '1985-10-20', '0987654321', 456, 'Avenue des Champs-Élysées', 75008);

INSERT INTO client_auth (client_id, compte_confirme, tentative_password, code_recuperation) VALUES
    (LAST_INSERT_ID(), TRUE, 0, NULL);