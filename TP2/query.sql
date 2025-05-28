CREATE DATABASE eventos_gomez;
GO

USE eventos_gomez;
GO

-- Creación de tablas
CREATE TABLE ADM_Paises (
    id_pais INT PRIMARY KEY,
    nombre_pais NVARCHAR(100) NOT NULL
);

CREATE TABLE ADM_Ciudades (
    id_ciudad INT PRIMARY KEY,
    nombre_ciudad NVARCHAR(100) NOT NULL,
    id_pais INT NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES ADM_Paises(id_pais)
);

CREATE TABLE FER_Predios (
    id_predio INT IDENTITY(1,1) PRIMARY KEY,
    nombre_predio NVARCHAR(100) NOT NULL,
    id_ciudad INT NOT NULL,
    superficie NUMERIC(9,0) NOT NULL,
    FOREIGN KEY (id_ciudad) REFERENCES ADM_Ciudades(id_ciudad)
);

CREATE TABLE FER_Rubros (
    id_rubro INT PRIMARY KEY,
    rubro NVARCHAR(100) NOT NULL
);

CREATE TABLE FER_Expos (
    id_feria INT PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    id_rubro INT NOT NULL,
    fecha_apertura DATETIME NOT NULL,
    fecha_cierre DATETIME NOT NULL,
    id_predio INT NOT NULL,
    FOREIGN KEY (id_rubro) REFERENCES FER_Rubros(id_rubro),
    FOREIGN KEY (id_predio) REFERENCES FER_Predios(id_predio)
);

-- Carga de datos
INSERT INTO ADM_Paises VALUES 
(1, 'Argentina'),
(2, 'Brasil'),
(3, 'Uruguay');

INSERT INTO ADM_Ciudades VALUES
(1, 'Rosario', 1),
(2, 'Cordoba', 1),
(3, 'Motevideo', 3),
(4, 'San Pablo', 2),
(5, 'Floria', 2),
(6, 'Santa Fe', 1);

INSERT INTO FER_Predios (nombre_predio, id_ciudad, superficie) VALUES
('La Posta', 1, 1200),
('El Quincho', 1, 1000),
('Francia', 3, 4000),
('El Palomar', 4, 2500),
('La Noche', 1, 200),
('La Estrella', 2, 5000),
('El Establo', 6, 600);

INSERT INTO FER_Rubros VALUES
(1, 'Promociones'),
(2, 'Cumpleaños'),
(3, 'Despedidas'),
(4, 'Casamientos');

INSERT INTO FER_Expos VALUES
(1, 'casamiento Juan', 4, '2007-08-25', '2007-08-25', 1),
(2, 'comidas ricas', 1, '2008-04-30', '2008-05-02', 4),
(3, 'fin2004', 3, '2004-12-20', '2004-12-21', 3),
(4, 'fin2005', 3, '2008-05-14', '2008-05-15', 1),
(5, 'casamiento Ariel', 4, '2009-01-05', '2009-01-06', 2),
(6, 'cumple15', 2, '2009-04-25', '2009-04-26', 2);

-- Creación de vistas
CREATE VIEW VW_Predios AS
SELECT 
    p.nombre_predio,
    c.nombre_ciudad,
    pa.nombre_pais
FROM FER_Predios p
JOIN ADM_Ciudades c ON p.id_ciudad = c.id_ciudad
JOIN ADM_Paises pa ON c.id_pais = pa.id_pais
WHERE p.nombre_predio LIKE 'L%';

CREATE VIEW VW_Feriashoy AS
SELECT 
    e.nombre AS nombre_feria,
    r.rubro,
    e.fecha_apertura,
    e.fecha_cierre
FROM FER_Expos e
JOIN FER_Rubros r ON e.id_rubro = r.id_rubro
WHERE e.fecha_apertura >= '2023-01-01' AND e.fecha_apertura <= GETDATE();

CREATE VIEW VW_Predios2 AS
SELECT 
    nombre_predio,
    id_ciudad,
    superficie
FROM FER_Predios;

-- INSERT INTO FER_Predios (nombre_predio, id_ciudad, superficie)
-- VALUES ('La Cabaña', 1, 1500);
