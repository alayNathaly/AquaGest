CREATE DATABASE IF NOT EXISTS `aquagest_db`
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE `aquagest_db`;

-- =====================================================
-- 1. TABLA USUARIO
-- =====================================================

CREATE TABLE `usuario` (
    `id_usuario` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL,
    `telefono` VARCHAR(20),
    `email` VARCHAR(150) UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,

    `rol` ENUM(
        'COMITE',
        'RESIDENTE',
        'OPERADOR'
    ) NOT NULL,

    `estado` ENUM(
        'ACTIVO',
        'INACTIVO'
    ) NOT NULL DEFAULT 'ACTIVO',

    `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX `idx_email` (`email`),
    INDEX `idx_rol` (`rol`)
) ENGINE=InnoDB;

-- =====================================================
-- 2. TABLA VIVIENDA
-- =====================================================

CREATE TABLE `vivienda` (
    `id_vivienda` BIGINT AUTO_INCREMENT PRIMARY KEY,

    `direccion` VARCHAR(200) NOT NULL,

    `sector` VARCHAR(50) NOT NULL,

    `numero_integrantes` INT,

    `estado_servicio` ENUM(
        'ACTIVO',
        'SUSPENDIDO',
        'CORTE'
    ) NOT NULL DEFAULT 'ACTIVO',

    `estado_cuenta` ENUM(
        'AL_DIA',
        'MOROSO'
    ) NOT NULL DEFAULT 'AL_DIA',

    `sincronizado` TINYINT(1) NOT NULL DEFAULT 0,

    `uuid_local` VARCHAR(36) UNIQUE,

    INDEX `idx_sector` (`sector`),
    INDEX `idx_estado_cuenta` (`estado_cuenta`),
    INDEX `idx_sincronizado` (`sincronizado`)
) ENGINE=InnoDB;

-- =====================================================
-- 3. TABLA USUARIO_VIVIENDA
-- =====================================================

CREATE TABLE `usuario_vivienda` (
    `id_usuario_vivienda` BIGINT AUTO_INCREMENT PRIMARY KEY,

    `id_usuario` BIGINT NOT NULL,

    `id_vivienda` BIGINT NOT NULL,

    `rol_en_vivienda` ENUM(
        'RESIDENTE',
        'OPERADOR',
        'SUPERVISOR'
    ) NOT NULL,

    `fecha_asignacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY `uk_usuario_vivienda` (`id_usuario`, `id_vivienda`),

    CONSTRAINT `fk_uv_usuario`
        FOREIGN KEY (`id_usuario`)
        REFERENCES `usuario`(`id_usuario`)
        ON DELETE CASCADE,

    CONSTRAINT `fk_uv_vivienda`
        FOREIGN KEY (`id_vivienda`)
        REFERENCES `vivienda`(`id_vivienda`)
        ON DELETE CASCADE,

    INDEX `idx_vivienda` (`id_vivienda`)
) ENGINE=InnoDB;

-- =====================================================
-- 4. TABLA PAGO
-- =====================================================

CREATE TABLE `pago` (
    `id_pago` BIGINT AUTO_INCREMENT PRIMARY KEY,

    `id_vivienda` BIGINT NOT NULL,

    `fecha_pago` DATETIME NOT NULL,

    `monto` DECIMAL(10,2) NOT NULL,

    `estado_pago` ENUM(
        'PAGADO',
        'ANULADO'
    ) NOT NULL DEFAULT 'PAGADO',

    `sincronizado` TINYINT(1) NOT NULL DEFAULT 0,

    `uuid_local` VARCHAR(36) UNIQUE,

    CONSTRAINT `fk_pago_vivienda`
        FOREIGN KEY (`id_vivienda`)
        REFERENCES `vivienda`(`id_vivienda`)
        ON DELETE CASCADE,

    INDEX `idx_vivienda_fecha` (`id_vivienda`, `fecha_pago`),
    INDEX `idx_sincronizado` (`sincronizado`)
) ENGINE=InnoDB;

-- =====================================================
-- 5. TABLA INCIDENCIA
-- =====================================================

CREATE TABLE `incidencia` (
    `id_incidencia` BIGINT AUTO_INCREMENT PRIMARY KEY,

    `tipo_incidencia` ENUM(
        'FUGA',
        'BAJA_PRESION',
        'CONTAMINACION',
        'OTRO'
    ) NOT NULL,

    `descripcion` TEXT NOT NULL,

    `fecha_reporte` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    `estado` ENUM(
        'PENDIENTE',
        'EN_PROCESO',
        'RESUELTA'
    ) NOT NULL DEFAULT 'PENDIENTE',

    `foto` VARCHAR(255),

    `sincronizado` TINYINT(1) NOT NULL DEFAULT 0,

    `uuid_local` VARCHAR(36) UNIQUE,

    `id_vivienda` BIGINT NULL,
    `id_usuario` BIGINT NULL,

    CONSTRAINT `fk_incidencia_vivienda`
        FOREIGN KEY (`id_vivienda`)
        REFERENCES `vivienda`(`id_vivienda`)
        ON DELETE SET NULL,

    CONSTRAINT `fk_incidencia_usuario`
        FOREIGN KEY (`id_usuario`)
        REFERENCES `usuario`(`id_usuario`)
        ON DELETE SET NULL,

    INDEX `idx_vivienda` (`id_vivienda`),
    INDEX `idx_usuario` (`id_usuario`),
    INDEX `idx_estado` (`estado`),
    INDEX `idx_sincronizado` (`sincronizado`)
) ENGINE=InnoDB;

-- =====================================================
-- 6. TABLA MANTENIMIENTO
-- =====================================================

CREATE TABLE `mantenimiento` (
    `id_mantenimiento` BIGINT AUTO_INCREMENT PRIMARY KEY,

    `descripcion` TEXT NOT NULL,

    `tipo_mantenimiento` ENUM(
        'PREVENTIVO',
        'CORRECTIVO'
    ) NOT NULL,

    `fecha_programada` DATETIME,

    `fecha_ejecucion` DATETIME,

    `costo` DECIMAL(10,2),

    `sincronizado` TINYINT(1) NOT NULL DEFAULT 0,

    `uuid_local` VARCHAR(36) UNIQUE,

    `id_responsable` BIGINT NULL,
    `id_incidencia` BIGINT NULL,

    CONSTRAINT `fk_mantenimiento_usuario`
        FOREIGN KEY (`id_responsable`)
        REFERENCES `usuario`(`id_usuario`)
        ON DELETE SET NULL,

    CONSTRAINT `fk_mantenimiento_incidencia`
        FOREIGN KEY (`id_incidencia`)
        REFERENCES `incidencia`(`id_incidencia`)
        ON DELETE SET NULL,

    INDEX `idx_incidencia` (`id_incidencia`),
    INDEX `idx_sincronizado` (`sincronizado`)
) ENGINE=InnoDB;

-- =====================================================
-- 7. TABLA TANQUE_AGUA
-- =====================================================

CREATE TABLE `tanque_agua` (
    `id_tanque` BIGINT AUTO_INCREMENT PRIMARY KEY,

    `nivel_actual` DECIMAL(10,2) NOT NULL,

    `capacidad_maxima` DECIMAL(10,2) NOT NULL,

    `fecha_registro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =====================================================
-- 8. TABLA DISTRIBUCION
-- =====================================================

CREATE TABLE `distribucion` (
    `id_distribucion` BIGINT AUTO_INCREMENT PRIMARY KEY,

    `sector` VARCHAR(50) NOT NULL,

    `fecha` DATE NOT NULL,

    `hora_inicio` TIME NOT NULL,

    `hora_fin` TIME NOT NULL,

    `estado` ENUM(
        'PROGRAMADA',
        'EJECUTADA',
        'CANCELADA'
    ) NOT NULL DEFAULT 'PROGRAMADA',

    `nivel_inicial` DECIMAL(5,2),

    `nivel_final` DECIMAL(5,2),

    `id_tanque` BIGINT NOT NULL,

    CONSTRAINT `fk_distribucion_tanque`
        FOREIGN KEY (`id_tanque`)
        REFERENCES `tanque_agua`(`id_tanque`)
        ON DELETE CASCADE,

    INDEX `idx_sector_fecha` (`sector`, `fecha`),
    INDEX `idx_estado` (`estado`)
) ENGINE=InnoDB;

-- =====================================================
-- 9. TABLA NOTIFICACION
-- =====================================================

CREATE TABLE `notificacion` (
    `id_notificacion` BIGINT AUTO_INCREMENT PRIMARY KEY,

    `tipo_evento` ENUM(
        'PAGO',
        'INCIDENCIA',
        'CORTE',
        'DISTRIBUCION'
    ) NOT NULL,

    `mensaje` TEXT NOT NULL,

    `fecha_envio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    `estado` ENUM(
        'PENDIENTE',
        'ENVIADA',
        'LEIDA'
    ) NOT NULL DEFAULT 'PENDIENTE',

    `id_usuario` BIGINT NOT NULL,

    CONSTRAINT `fk_notificacion_usuario`
        FOREIGN KEY (`id_usuario`)
        REFERENCES `usuario`(`id_usuario`)
        ON DELETE CASCADE,

    INDEX `idx_usuario_estado` (`id_usuario`, `estado`)
) ENGINE=InnoDB;

-- =====================================================
-- 10. TABLA BITACORA
-- =====================================================

CREATE TABLE `bitacora` (
    `id_bitacora` BIGINT AUTO_INCREMENT PRIMARY KEY,

    `accion` VARCHAR(100) NOT NULL,

    `fecha` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    `descripcion` TEXT,

    `id_usuario` BIGINT NULL,

    CONSTRAINT `fk_bitacora_usuario`
        FOREIGN KEY (`id_usuario`)
        REFERENCES `usuario`(`id_usuario`)
        ON DELETE SET NULL,

    INDEX `idx_fecha` (`fecha`),
    INDEX `idx_usuario` (`id_usuario`)
) ENGINE=InnoDB;

-- =====================================================
-- DATOS DE PRUEBA
-- =====================================================

INSERT INTO `usuario`
(`nombre`, `telefono`, `email`, `password_hash`, `rol`)
VALUES
('Admin Comité', '0999999', 'comite@aquagest.com', '$2a$10$hashEjemplo1', 'COMITE'),
('Juan Residente', '0988888', 'residente@aquagest.com', '$2a$10$hashEjemplo2', 'RESIDENTE'),
('Luis Operador', '0977777', 'operador@aquagest.com', '$2a$10$hashEjemplo3', 'OPERADOR');

INSERT INTO `vivienda`
(`direccion`, `sector`, `numero_integrantes`, `estado_cuenta`)
VALUES
('Calle Falsa 123', 'Sector Norte', 4, 'AL_DIA'),
('Av. Principal 456', 'Sector Sur', 3, 'MOROSO');

INSERT INTO `usuario_vivienda`
(`id_usuario`, `id_vivienda`, `rol_en_vivienda`)
VALUES
(2, 1, 'RESIDENTE'),
(3, 1, 'OPERADOR');

INSERT INTO `tanque_agua`
(`nivel_actual`, `capacidad_maxima`)
VALUES
(850.50, 1000.00);