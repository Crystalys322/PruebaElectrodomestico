-- -----------------------------------------------------
-- Base de datos para el proyecto PruebaElectrodomestico
-- Compatible con MySQL 8.x / MariaDB 10.x
-- -----------------------------------------------------

DROP DATABASE IF EXISTS tiendaelectrodomestico_jvl;
CREATE DATABASE tiendaelectrodomestico_jvl
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;

USE tiendaelectrodomestico_jvl;

-- -----------------------------------------------------
-- Tabla: categoria
-- Catálogo de categorías para agrupar productos.
-- -----------------------------------------------------
CREATE TABLE categoria (
  idCategoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(80)  NOT NULL,
  descripcion VARCHAR(255) NULL
) ENGINE = InnoDB;

INSERT INTO categoria (nombre, descripcion) VALUES
  ('Televisores', 'Pantallas LED, QLED y OLED de diversas pulgadas'),
  ('Refrigeradoras', 'Línea blanca y frigoríficos inteligentes'),
  ('Lavadoras', 'Lavadoras automáticas y semi automáticas'),
  ('Pequeños Electrodomésticos', 'Accesorios y pequeños aparatos para el hogar');

-- -----------------------------------------------------
-- Tabla: producto
-- Registro maestro de productos comercializados.
-- -----------------------------------------------------
CREATE TABLE producto (
  idProducto  INT AUTO_INCREMENT PRIMARY KEY,
  nombre      VARCHAR(120)      NOT NULL,
  descripcion TEXT               NULL,
  precio      DECIMAL(10,2)      NOT NULL,
  stock       INT                NOT NULL DEFAULT 0,
  idCategoria INT                NOT NULL,
  estado      VARCHAR(20)        NOT NULL DEFAULT 'ACTIVO',
  CONSTRAINT fk_producto_categoria
    FOREIGN KEY (idCategoria)
    REFERENCES categoria (idCategoria)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

INSERT INTO producto (nombre, descripcion, precio, stock, idCategoria, estado) VALUES
  ('Smart TV 55" 4K', 'Televisor inteligente con soporte HDR10 y Android TV.', 2599.90, 12, 1, 'ACTIVO'),
  ('Smart TV 65" OLED', 'Panel OLED con Dolby Vision, Dolby Atmos y asistentes integrados.', 4899.00, 6, 1, 'ACTIVO'),
  ('Barra de Sonido 5.1', 'Sistema de sonido envolvente con subwoofer inalámbrico.', 1299.50, 10, 1, 'ACTIVO'),
  ('Refrigeradora No Frost 420L', 'Refrigeradora con dispensador de agua y control digital.', 1999.50, 8, 2, 'ACTIVO'),
  ('Refrigeradora Side by Side 520L', 'Panel táctil, tecnología inverter y fábrica de hielo automática.', 3299.90, 4, 2, 'ACTIVO'),
  ('Lavadora Carga Frontal 15Kg', 'Lavadora con múltiples programas y motor inverter.', 1699.00, 5, 3, 'ACTIVO'),
  ('Secadora Eléctrica 10Kg', 'Tambor de acero inoxidable con sensor de humedad.', 1399.00, 3, 3, 'ACTIVO'),
  ('Licuadora Profesional 1.8L', 'Motor de alta potencia y cuchillas de acero inoxidable.', 299.90, 20, 4, 'ACTIVO'),
  ('Freidora de Aire 6L', 'Programas preconfigurados y control digital de temperatura.', 459.90, 15, 4, 'ACTIVO'),
  ('Cafetera Espresso Automática', 'Molinillo integrado, vaporizador de leche y pantalla táctil.', 1899.00, 7, 4, 'ACTIVO');

-- -----------------------------------------------------
-- Tabla: cliente
-- Datos personales de los clientes.
-- -----------------------------------------------------
CREATE TABLE cliente (
  idCliente INT AUTO_INCREMENT PRIMARY KEY,
  nombres   VARCHAR(80)  NOT NULL,
  apellidos VARCHAR(100) NOT NULL,
  dni       VARCHAR(15)  NOT NULL UNIQUE,
  telefono  VARCHAR(20)  NULL,
  correo    VARCHAR(120) NULL,
  direccion VARCHAR(200) NULL
) ENGINE = InnoDB;

INSERT INTO cliente (nombres, apellidos, dni, telefono, correo, direccion) VALUES
  ('Juan', 'Perez Ramos', '12345678', '999888777', 'juan.perez@example.com', 'Av. Los Próceres 123 - Lima'),
  ('María', 'Lopez Huaman', '87654321', '988777666', 'maria.lopez@example.com', 'Jr. Las Flores 456 - Arequipa');

-- -----------------------------------------------------
-- Tabla: usuario
-- Cuentas de acceso para el personal del sistema.
-- -----------------------------------------------------
CREATE TABLE usuario (
  idUsuario INT AUTO_INCREMENT PRIMARY KEY,
  usuario   VARCHAR(60)  NOT NULL UNIQUE,
  clave     VARCHAR(120) NOT NULL,
  rol       VARCHAR(40)  NOT NULL DEFAULT 'VENDEDOR',
  estado    VARCHAR(20)  NOT NULL DEFAULT 'ACTIVO'
) ENGINE = InnoDB;

INSERT INTO usuario (usuario, clave, rol, estado) VALUES
  ('admin', 'admin123', 'ADMIN', 'ACTIVO'),
  ('vendedor1', 'venta2024', 'VENDEDOR', 'ACTIVO');

-- -----------------------------------------------------
-- Tabla: venta
-- Cabecera de la transacción de venta.
-- -----------------------------------------------------
CREATE TABLE venta (
  idVenta   INT AUTO_INCREMENT PRIMARY KEY,
  idCliente INT            NOT NULL,
  idUsuario INT            NOT NULL,
  fecha     DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  total     DECIMAL(10,2)  NOT NULL,
  estado    VARCHAR(20)    NOT NULL DEFAULT 'REGISTRADA',
  CONSTRAINT fk_venta_cliente
    FOREIGN KEY (idCliente)
    REFERENCES cliente (idCliente)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,
  CONSTRAINT fk_venta_usuario
    FOREIGN KEY (idUsuario)
    REFERENCES usuario (idUsuario)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Tabla: detalle_venta
-- Detalle de productos asociados a cada venta.
-- -----------------------------------------------------
CREATE TABLE detalle_venta (
  idDetalle      INT AUTO_INCREMENT PRIMARY KEY,
  idVenta        INT           NOT NULL,
  idProducto     INT           NOT NULL,
  cantidad       INT           NOT NULL,
  precioUnitario DECIMAL(10,2) NOT NULL,
  subtotal       DECIMAL(10,2) NOT NULL,
  CONSTRAINT fk_detalle_venta
    FOREIGN KEY (idVenta)
    REFERENCES venta (idVenta)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT fk_detalle_producto
    FOREIGN KEY (idProducto)
    REFERENCES producto (idProducto)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE = InnoDB;

-- Datos de ejemplo para una venta completa
INSERT INTO venta (idCliente, idUsuario, fecha, total, estado)
VALUES (1, 1, NOW(), 2899.80, 'REGISTRADA');

INSERT INTO detalle_venta (idVenta, idProducto, cantidad, precioUnitario, subtotal) VALUES
  (1, 1, 1, 2599.90, 2599.90),
  (1, 4, 1, 299.90, 299.90);

-- Ajuste de stock por venta de ejemplo
UPDATE producto
   SET stock = stock - 1
 WHERE idProducto IN (1, 4);

-- -----------------------------------------------------
-- Vistas de apoyo
-- -----------------------------------------------------
CREATE OR REPLACE VIEW vw_productos_activos AS
SELECT p.idProducto,
       p.nombre,
       p.descripcion,
       p.precio,
       p.stock,
       p.estado,
       c.nombre AS categoria
  FROM producto p
  JOIN categoria c ON c.idCategoria = p.idCategoria
 WHERE p.estado <> 'ELIMINADO';

CREATE OR REPLACE VIEW vw_detalle_ventas AS
SELECT v.idVenta,
       v.fecha,
       v.total,
       v.estado,
       c.nombres    AS clienteNombres,
       c.apellidos  AS clienteApellidos,
       u.usuario    AS usuarioSistema,
       d.idDetalle,
       d.idProducto,
       d.cantidad,
       d.precioUnitario,
       d.subtotal
  FROM venta v
  JOIN cliente c       ON c.idCliente = v.idCliente
  JOIN usuario u       ON u.idUsuario = v.idUsuario
  JOIN detalle_venta d ON d.idVenta = v.idVenta;
