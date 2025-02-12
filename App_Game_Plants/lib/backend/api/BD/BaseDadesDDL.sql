-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS appPlantes CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE appPlantes;

-- Crear la tabla `usuaris`
CREATE TABLE `usuaris` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(100) DEFAULT NULL,
  `correu` VARCHAR(100) DEFAULT NULL,
  `contrasenya` VARCHAR(100) DEFAULT NULL,
  `edat` INT DEFAULT NULL,
  `nacionalitat` VARCHAR(50) DEFAULT NULL,
  `codiPostal` VARCHAR(20) DEFAULT NULL,
  `imatgePerfil` VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Crear la tabla `plantas`
CREATE TABLE `plantas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `usuari_id` INT NOT NULL,
  `nom` VARCHAR(100) NOT NULL,
  `tipus` VARCHAR(50) NOT NULL,
  `nivell` INT NOT NULL,
  `atac` INT NOT NULL,
  `defensa` INT NOT NULL,
  `velocitat` INT NOT NULL,
  `habilitat_especial` VARCHAR(100) DEFAULT NULL,
  `energia` INT NOT NULL,
  `estat` VARCHAR(50) DEFAULT 'actiu',
  `raritat` VARCHAR(50) NOT NULL,
  `ultima_actualitzacio` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `imatge` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `usuari_id` (`usuari_id`),
  CONSTRAINT `fk_plantas_usuaris` FOREIGN KEY (`usuari_id`) 
    REFERENCES `usuaris` (`id`) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=211 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
