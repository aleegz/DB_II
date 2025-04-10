CREATE DATABASE ej2;

GO

USE ej2;

CREATE TABLE localidades (
	cp INT PRIMARY KEY,
	localidad NVARCHAR(60)
);

CREATE TABLE clientes (
	id_cliente INT PRIMARY KEY,
	nombre NVARCHAR(80),
	direccion_c NVARCHAR(80),
	direccion_n INT,
	cp INT FOREIGN KEY REFERENCES localidades(cp),
	contador INT,
	acumulador MONEY
);

CREATE TABLE equipos (
	id_equipo INT PRIMARY KEY,
	descripcion NVARCHAR(80),
	id_cliente INT,
	importe MONEY 
);

CREATE TABLE tecnicos (
	clave_tec INT PRIMARY KEY,
	nombre NVARCHAR(80),
	contador INT,
	acumulador MONEY
);

CREATE TABLE reparaciones (
	id_trabajo INT PRIMARY KEY,
	clave_tec INT FOREIGN KEY REFERENCES tecnicos(clave_tec),
	id_equipo INT FOREIGN KEY REFERENCES equipos(id_equipo),
	importe MONEY,
	fecha_ini DATETIME,
	fecha_fin DATETIME
);

-- CARGA DE DATOS

INSERT INTO localidades (cp, localidad) VALUES
(1000, 'Buenos Aires'),
(2000, 'Rosario'),
(3000, 'Santa Fe');

INSERT INTO clientes (id_cliente, nombre, direccion_c, direccion_n, cp, contador, acumulador) VALUES
(1, 'Juan Pérez', 'Av. Rivadavia', 1234, 1000, 0, 0),
(2, 'María López', 'Calle Mitre', 567, 2000, 0, 0),
(3, 'Carlos Gómez', 'Boulevard Oroño', 890, 3000, 0, 0);

INSERT INTO equipos (id_equipo, descripcion, id_cliente, importe) VALUES
(101, 'Notebook Lenovo', 1, 50000),
(102, 'PC Gamer', 1, 120000),
(103, 'Impresora HP', 2, 30000),
(104, 'Monitor LG', 3, 25000);

INSERT INTO tecnicos (clave_tec, nombre, contador, acumulador) VALUES
(1, 'Tec. Ramírez', 0, 0),
(2, 'Tec. Fernández', 0, 0);

INSERT INTO reparaciones (id_trabajo, clave_tec, id_equipo, importe, fecha_ini, fecha_fin) VALUES
(1, 1, 101, 8000, '2025-04-01 08:00:00', '2025-04-01 10:00:00'),
(2, 1, 102, 15000, '2025-04-03 09:00:00', '2025-04-03 12:00:00'),
(3, 2, 103, 5000, '2025-04-02 11:00:00', '2025-04-02 13:00:00'),
(4, 2, 104, 7000, '2025-04-05 14:00:00', '2025-04-05 16:30:00');

-- CONSULTAS

-- 4) Mostrar los clientes con su localidad

SELECT id_cliente, nombre, direccion_c, localidad FROM clientes
INNER JOIN localidades ON clientes.cp = localidades.cp;

-- 5) Cuántos clientes hay por localidad.

SELECT COUNT(id_cliente) cantidad, localidad FROM clientes
JOIN localidades ON clientes.cp = localidades.cp
GROUP BY localidad;

-- 6) Cuantos equipos tiene cada cliente.

SELECT c.id_cliente, c.nombre, COUNT(e.id_equipo) cantidad_equipos
FROM clientes c
LEFT JOIN equipos e ON c.id_cliente = e.id_cliente
GROUP BY c.id_cliente, c.nombre;

-- 7) Mostrar una reparación completa. (Todos los datos asociados a la misma).

SELECT id_trabajo Trabajo, clave_tec Técnico, id_equipo Equipo, importe Importe, fecha_ini Fecha_Inicio, fecha_fin Fecha_Fin FROM reparaciones

-- 8) Mostrar todas las reparaciones de un técnico en un rango de fechas.

SELECT COUNT(id_trabajo) reparaciones, clave_tec tecnico FROM reparaciones
GROUP BY clave_tec;

-- 9) Calcular el importe de las reparaciones de todos los equipos de un cliente.

CREATE PROCEDURE importeTotal @id_cliente INT
AS
BEGIN
	SELECT c.id_cliente, c.nombre, SUM(r.importe) TotalImporte
	FROM clientes c
	JOIN equipos e ON c.id_cliente = e.id_cliente
	JOIN reparaciones r ON e.id_equipo = r.id_equipo
	WHERE c.id_cliente = @id_cliente
	GROUP BY c.id_cliente, c.nombre;
END;
GO