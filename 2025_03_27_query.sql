CREATE DATABASE ej1;

GO;

USE ej1;

-- CREACIÓN DE TABLAS 

CREATE TABLE Localidades (
	cp INT PRIMARY KEY,
	localidad NVARCHAR(255)
);

CREATE TABLE Propietarios (
	cuit NVARCHAR(11) PRIMARY KEY,
	apellido NVARCHAR(255),
	nombre NVARCHAR(255),
	telefono NVARCHAR(255),
	domicilio NVARCHAR(255),
	email NVARCHAR(255),
	codigo_postal INT FOREIGN KEY REFERENCES Localidades(cp)
);

CREATE TABLE Avion (
	id INT PRIMARY KEY,
	capacidad INT,
	tipo NVARCHAR(255),
	anio_fabricacion INT,
	propietario NVARCHAR(11) FOREIGN KEY REFERENCES Propietarios(cuit)
);

CREATE TABLE Pasajeros (
	dni INT PRIMARY KEY,
	apellido NVARCHAR(255),
	nombre NVARCHAR(255),
	telefono NVARCHAR(255),
	domicilio NVARCHAR(255),
	email NVARCHAR(255),
	codigo_postal INT FOREIGN KEY REFERENCES Localidades(cp)
);

CREATE TABLE Vuelo (
	nro_vuelo INT PRIMARY KEY,
	origen NVARCHAR(255),
	destino NVARCHAR(255),
	km INT,
	fecha DATE,
	hora_salida DATETIME,
	hora_llegada DATETIME,
	avion INT FOREIGN KEY REFERENCES Avion(id),
	pasajero INT FOREIGN KEY REFERENCES Pasajeros(dni)
);

CREATE TABLE VueloPasajero (
    nro_vuelo INT FOREIGN KEY REFERENCES Vuelo(nro_vuelo),
    dni_pasajero INT FOREIGN KEY REFERENCES Pasajeros(dni),
    PRIMARY KEY (nro_vuelo, dni_pasajero)
);

-- CARGA DE DATOS

INSERT INTO Localidades (cp, localidad) VALUES
(1000, 'Buenos Aires'),
(2000, 'Rosario'),
(3000, 'Santa Fe');

INSERT INTO Propietarios (cuit, apellido, nombre, telefono, domicilio, email, codigo_postal) VALUES
('20123456789', 'Gonzalez', 'Mario', '123456789', 'Calle Falsa 123', 'mario@gonzalez.com', 1000),
('20987654321', 'Pérez', 'Lucía', '987654321', 'Av. Siempreviva 742', 'lucia@perez.com', 2000);

INSERT INTO Avion (id, capacidad, tipo, anio_fabricacion, propietario) VALUES
(1, 150, 'Boeing 737', 2005, '20123456789'),
(2, 120, 'Airbus A320', 2010, '20123456789'),
(3, 100, 'Embraer 190', 2015, '20987654321');

INSERT INTO Pasajeros (dni, apellido, nombre, telefono, domicilio, email, codigo_postal) VALUES
(11111111, 'López', 'Ana', '3411234567', 'San Martín 100', 'ana@lopez.com', 1000),
(22222222, 'Martínez', 'Juan', '3417654321', 'Belgrano 200', 'juan@martinez.com', 2000),
(33333333, 'Ramírez', 'Carlos', '3419876543', 'Mitre 300', 'carlos@ramirez.com', 3000);

INSERT INTO Vuelo (nro_vuelo, origen, destino, km, fecha, hora_salida, hora_llegada, avion, pasajero) VALUES
(101, 'Buenos Aires', 'Rosario', 300, '2025-04-01', '2025-04-01 08:00:00', '2025-04-01 09:00:00', 1, NULL),
(102, 'Rosario', 'Santa Fe', 200, '2025-04-01', '2025-04-01 10:00:00', '2025-04-01 10:45:00', 1, NULL),
(103, 'Santa Fe', 'Buenos Aires', 500, '2025-04-02', '2025-04-02 14:00:00', '2025-04-02 15:30:00', 2, NULL);

INSERT INTO VueloPasajero (nro_vuelo, dni_pasajero) VALUES
(101, 11111111),
(101, 22222222),
(102, 11111111),
(103, 33333333),
(103, 22222222);

-- 1) MOSTRAR TODOS LOS PROPIETARIOS

SELECT * FROM Propietarios;

-- 2) MOSTRAR TODOS LOS PROPIETARIOS ORDENADOS POR APELLIDO

SELECT * FROM Propietarios ORDER BY apellido;

-- 3) MOSTRAR TODOS LOS PROPIETARIOS QUE TENGAN MÁS DE UN AVIÓN Y MOSTRAR CUANTOS

SELECT propietario, COUNT(*) Cantidad
FROM Avion
GROUP BY propietario
HAVING COUNT(*) > 1;

-- PRIMERO GROUP BY, DESPUÉS COUNT Y LUEGO HAVING

-- 4) Mostrar la cantidad de pasajeros que volaron en nuestra empresa.

SELECT COUNT(DISTINCT dni_pasajero) FROM VueloPasajero;

-- 5) Mostrar los 3 pasajero que mas veces volaron.

SELECT TOP 3 P.dni DNI, COUNT(VP.nro_vuelo) Cantidad_Vuelos
FROM Pasajeros P
JOIN VueloPasajero VP ON P.dni = VP.dni_pasajero
GROUP BY P.dni
ORDER BY cantidad_vuelos DESC;

-- 6) Mostrar aquellos pasajeros que solo volaron una vez

SELECT P.dni DNI, COUNT(VP.nro_vuelo) Cantidad_Vuelos
FROM Pasajeros P
JOIN VueloPasajero VP ON P.dni = VP.dni_pasajero
GROUP BY P.dni
HAVING COUNT(VP.nro_vuelo) = 1;

-- 7) Mostrar las localidades en las cual residen la mayoria de nuestros pasajeros. (las 3 --principales)

SELECT TOP 3 L.localidad Localidad, COUNT(*) Cantidad_Pasajeros
FROM Pasajeros P
JOIN Localidades L ON P.codigo_postal = L.cp
JOIN VueloPasajero VP ON P.dni = VP.dni_pasajero
GROUP BY L.localidad
ORDER BY cantidad_pasajeros DESC;

-- 8) Mostrar las 3 aeronaves mas antiguas junto con los datos de su propietario

SELECT TOP 3 A.id ID, A.anio_fabricacion Fecha_Fabricacion, P.apellido Apellido, P.nombre Nombre, P.telefono Telefono, P.domicilio Domicilio, P.email Email
FROM Avion A
JOIN Propietarios P ON A.propietario = P.cuit
ORDER BY A.anio_fabricacion ASC;

-- 9) Mostrar todos los vuelos que realizaron escalas

SELECT v1.nro_vuelo, v1.origen, v1.destino, v1.fecha, v1.hora_salida, v1.hora_llegada, v2.nro_vuelo AS vuelo_siguiente, v2.origen AS siguiente_origen, v2.destino AS siguiente_destino, v2.fecha AS siguiente_fecha, v2.hora_salida AS siguiente_hora_salida, v2.hora_llegada AS siguiente_hora_llegada
FROM Vuelo v1
JOIN Vuelo v2 ON v1.destino = v2.origen
WHERE DATEDIFF(MINUTE, v1.hora_llegada, v2.hora_salida) BETWEEN 0 AND 180
ORDER BY v1.nro_vuelo;

-- 10) Mostrar la cantidad total de pasajeros por vuelos

SELECT V.nro_vuelo, COUNT(VP.dni_pasajero) Total_Pasajeros FROM Vuelo V
INNER JOIN VueloPasajero VP ON V.nro_vuelo = VP.nro_vuelo
GROUP BY V.nro_vuelo;