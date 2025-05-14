-- 1) Crear base de datos
CREATE DATABASE alto_gomez;
GO

USE alto_gomez;
GO

-- 2) Crear tablas, claves, relaciones y restricciones
CREATE TABLE proveedores (
    id_proveedor INT PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    ciudad NVARCHAR(50),
    telefono NVARCHAR(20)
);

CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    ciudad NVARCHAR(50),
    telefono NVARCHAR(20),
    dom_ent_calle NVARCHAR(100),
    dom_ent_num NVARCHAR(10)
);

CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    descripcion NVARCHAR(200),
    precio DECIMAL(10,2),
    peso DECIMAL(10,2),
    id_proveedor INT,
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

CREATE TABLE pedidos (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    fecha DATE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE pedido_detalle (
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- 3) Carga de datos
INSERT INTO proveedores (id_proveedor, nombre, ciudad, telefono) VALUES 
(1, 'Proveedor A', 'Ciudad1', '123456789'),
(2, 'Proveedor B', 'Ciudad2', '987654321');

INSERT INTO clientes (id_cliente, nombre, ciudad, telefono, dom_ent_calle, dom_ent_num) VALUES
(1, 'Cliente Uno', 'Ciudad1', '111222333', 'Calle Falsa', '123'),
(2, 'Cliente Dos', 'Ciudad3', '444555666', 'Avenida Siempre Viva', '742');

INSERT INTO productos (id_producto, descripcion, precio, peso, id_proveedor) VALUES
(8, 'Producto 8', 100.00, 2.5, 1),
(11, 'Producto 11', 150.00, 3.0, 2);

INSERT INTO pedidos (id_pedido, id_cliente, fecha) VALUES
(100, 1, '2025-04-01'),
(101, 2, '2025-04-02');

INSERT INTO pedido_detalle (id_pedido, id_producto, cantidad) VALUES
(100, 8, 10),
(100, 11, 5),
(101, 11, 2);

-- 4) Mostrar todas las localidades (sin repetir) en la que existen proveedores
SELECT ciudad 
FROM proveedores 
GROUP BY ciudad;

-- 5) Mostrar proveedores ordenados por razón social
SELECT id_proveedor, nombre, ciudad, telefono 
FROM proveedores
ORDER BY nombre;

-- 6) Mostrar id_producto y peso de los productos 8 y 11
SELECT id_producto, peso 
FROM productos 
WHERE id_producto IN (8, 11);

-- 7) Calcular el promedio de peso de todos los productos
SELECT AVG(peso) AS promedio_peso 
FROM productos;

-- 8) Contar cuántos clientes hay por ciudad
SELECT ciudad, COUNT(*) AS cantidad_clientes 
FROM clientes 
GROUP BY ciudad;

-- 9) Mostrar id_pedido, fecha y dirección completa de entrega
SELECT 
    p.id_pedido, 
    p.fecha,
    c.dom_ent_calle + ' ' + c.dom_ent_num AS direccion_entrega
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente;

-- 10) Mostrar el nombre del proveedor afectado a cada pedido
SELECT 
    p.id_pedido, 
    pr.nombre AS proveedor
FROM pedidos p
JOIN pedido_detalle pd ON p.id_pedido = pd.id_pedido
JOIN productos prd ON pd.id_producto = prd.id_producto
JOIN proveedores pr ON prd.id_proveedor = pr.id_proveedor
GROUP BY p.id_pedido, pr.nombre
ORDER BY p.id_pedido;