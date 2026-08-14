DROP DATABASE IF EXISTS gaseosas_del_valle;
CREATE DATABASE gaseosas_del_valle;
USE gaseosas_del_valle;


CREATE TABLE sedes (
    id_sede                 INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sede              VARCHAR(100) NOT NULL,
    ubicacion                VARCHAR(150) NOT NULL,
    capacidad_almacenamiento INT NOT NULL DEFAULT 0,
    encargado                VARCHAR(100)
);


CREATE TABLE clientes (
    id_cliente         INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo     VARCHAR(120) NOT NULL,
    identificacion      VARCHAR(20)  NOT NULL UNIQUE,
    direccion            VARCHAR(150),
    telefono             VARCHAR(20),
    correo_electronico   VARCHAR(100) UNIQUE
);


CREATE TABLE productos (
    id_producto     INT AUTO_INCREMENT PRIMARY KEY,
    nombre           VARCHAR(100) NOT NULL,
    categoria        VARCHAR(50)  NOT NULL,
    precio           DECIMAL(10,2) NOT NULL CHECK (precio > 0),
    volumen_ml       INT NOT NULL CHECK (volumen_ml > 0),
    stock_actual     INT NOT NULL DEFAULT 0,
    stock_minimo     INT NOT NULL DEFAULT 0
);

CREATE TABLE pedidos (
    id_pedido      INT AUTO_INCREMENT PRIMARY KEY,
    fecha_pedido    DATE NOT NULL,
    id_cliente      INT NOT NULL,
    id_sede         INT NOT NULL,
    total_sin_iva   DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_con_iva   DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_sede) REFERENCES sedes(id_sede)
        ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE detalle_pedido (
    id_detalle    INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido      INT NOT NULL,
    id_producto    INT NOT NULL,
    cantidad       INT NOT NULL CHECK (cantidad > 0),
    subtotal       DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE RESTRICT ON UPDATE CASCADE
);


CREATE TABLE auditoria_precios (
    id_auditoria    INT AUTO_INCREMENT PRIMARY KEY,
    id_producto      INT NOT NULL,
    precio_anterior  DECIMAL(10,2) NOT NULL,
    precio_nuevo     DECIMAL(10,2) NOT NULL,
    fecha_cambio     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
        ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO sedes (nombre_sede, ubicacion, capacidad_almacenamiento, encargado) VALUES
('Sede Girón Centro',      'Girón, Santander',      5000, 'Carlos Ramírez'),
('Sede Bucaramanga Norte', 'Bucaramanga, Santander', 8000, 'Diana Torres'),
('Sede Piedecuesta',       'Piedecuesta, Santander', 3000, 'Andrés Suárez');

INSERT INTO clientes (nombre_completo, identificacion, direccion, telefono, correo_electronico) VALUES
('María García Pérez',    '1091234567', 'Cra 10 # 5-20, Girón',        '3001112233', 'maria.garcia@correo.com'),
('Luis García Rodríguez', '1091234568', 'Cl 15 # 8-10, Bucaramanga',   '3002223344', 'luis.garcia@correo.com'),
('Sofía Martínez Luna',   '1091234569', 'Cra 27 # 45-12, Piedecuesta', '3003334455', 'sofia.martinez@correo.com'),
('Jorge Peña Gómez',      '1091234570', 'Cl 33 # 12-40, Girón',        '3004445566', 'jorge.pena@correo.com');

INSERT INTO productos (nombre, categoria, precio, volumen_ml, stock_actual, stock_minimo) VALUES
('Gaseosa Cola 400ml',       'Gaseosa', 2500.00, 400,  20, 30),
('Gaseosa Naranja 400ml',    'Gaseosa', 2500.00, 400,  50, 30),
('Agua sin gas 600ml',       'Agua',    1800.00, 600,  15, 20),
('Jugo de Mango 300ml',      'Jugo',    2200.00, 300,   8, 15),
('Gaseosa Cola 1.5L',        'Gaseosa', 5500.00, 1500, 40, 25),
('Bebida Energizante 250ml', 'Energizante', 4200.00, 250, 12, 10);

INSERT INTO pedidos (fecha_pedido, id_cliente, id_sede, total_sin_iva, total_con_iva) VALUES
('2026-01-10', 1, 1, 0, 0),
('2026-01-15', 2, 2, 0, 0),
('2026-02-02', 1, 1, 0, 0),
('2026-02-20', 3, 3, 0, 0),
('2026-03-05', 4, 1, 0, 0);


INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, subtotal) VALUES
(1, 1, 3, 3 * 2500.00),
(1, 3, 2, 2 * 1800.00),
(2, 2, 5, 5 * 2500.00),
(3, 5, 2, 2 * 5500.00),
(3, 4, 1, 1 * 2200.00),
(4, 1, 4, 4 * 2500.00),
(5, 6, 2, 2 * 4200.00),
(5, 2, 3, 3 * 2500.00);

