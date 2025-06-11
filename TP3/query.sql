CREATE DATABASE BancoDB;
GO

USE BancoDB;
GO

CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    apellido_cli NVARCHAR(100),
    nombre_cli NVARCHAR(100),
    dni NVARCHAR(100),
    telefono NVARCHAR(100),
    fecha_nac DATETIME
);

CREATE TABLE Cuentas (
    id_cuenta INT PRIMARY KEY,
    id_cliente INT,
    saldo DECIMAL(18, 2),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Movimientos (
    id_movimiento INT PRIMARY KEY,
    id_cuenta INT,
    saldo_ant DECIMAL(18, 2),
    saldo_post DECIMAL(18, 2),
    importe DECIMAL(18, 2),
    fecha_mov DATETIME,
    FOREIGN KEY (id_cuenta) REFERENCES Cuentas(id_cuenta)
);

CREATE PROCEDURE spd_addClientes
@id_cliente INT,
@apellido_cli NVARCHAR(100),
@nombre_cli NVARCHAR(100),
@dni NVARCHAR(100),
@telefono NVARCHAR(100),
@fecha_nac DATETIME
AS
BEGIN
    INSERT INTO Clientes (id_cliente, apellido_cli, nombre_cli, dni, telefono, fecha_nac)
    VALUES (@id_cliente, @apellido_cli, @nombre_cli, @dni, @telefono, @fecha_nac)
END;
GO

CREATE PROCEDURE spd_addCuentas
@id_cuenta INT,
@id_cliente INT,
@saldo DECIMAL(18, 2)
AS
BEGIN
    INSERT INTO Cuentas (id_cuenta, id_cliente, saldo)
    VALUES (@id_cuenta, @id_cliente, @saldo)
END;
GO

CREATE PROCEDURE spd_addMovimientos
@id_movimiento INT,
@id_cuenta INT,
@saldo_ant DECIMAL(18, 2),
@saldo_post DECIMAL(18, 2),
@importe DECIMAL(18, 2),
@fecha_mov DATETIME
AS
BEGIN
    INSERT INTO Movimientos (id_movimiento, id_cuenta, saldo_ant, saldo_post, importe, fecha_mov)
    VALUES (@id_movimiento, @id_cuenta, @saldo_ant, @saldo_post, @importe, @fecha_mov)
END;
GO

CREATE PROCEDURE spd_delClientes
@id_cliente INT
AS
BEGIN
    DELETE FROM Clientes WHERE id_cliente = @id_cliente
END;
GO

CREATE PROCEDURE spd_delCuentas
@id_cuenta INT
AS
BEGIN
    DELETE FROM Cuentas WHERE id_cuenta = @id_cuenta
END;
GO

CREATE PROCEDURE spd_delMovimientos
@id_movimiento INT
AS
BEGIN
    DELETE FROM Movimientos WHERE id_movimiento = @id_movimiento
END;
GO

CREATE PROCEDURE spd_upClientes
@id_cliente INT,
@apellido_cli NVARCHAR(100),
@nombre_cli NVARCHAR(100),
@dni NVARCHAR(100),
@telefono NVARCHAR(100),
@fecha_nac DATETIME
AS
BEGIN
    UPDATE Clientes
    SET apellido_cli = @apellido_cli,
        nombre_cli = @nombre_cli,
        dni = @dni,
        telefono = @telefono,
        fecha_nac = @fecha_nac
    WHERE id_cliente = @id_cliente
END;
GO

CREATE PROCEDURE spd_upCuentas
@id_cuenta INT,
@id_cliente INT,
@saldo DECIMAL(18,2)
AS
BEGIN
    UPDATE Cuentas
    SET id_cliente = @id_cliente,
        saldo = @saldo
    WHERE id_cuenta = @id_cuenta
END;
GO

CREATE PROCEDURE spd_upMovimientos
@id_movimiento INT,
@id_cuenta INT,
@saldo_ant DECIMAL(18,2),
@saldo_post DECIMAL(18,2),
@importe DECIMAL(18,2),
@fecha_mov DATETIME
AS
BEGIN
    UPDATE Movimientos
    SET id_cuenta = @id_cuenta,
        saldo_ant = @saldo_ant,
        saldo_post = @saldo_post,
        importe = @importe,
        fecha_mov = @fecha_mov
    WHERE id_movimiento = @id_movimiento
END;
GO

CREATE PROCEDURE spu_ObtenerSaldoCuenta
    @id_cuenta INT
AS
BEGIN
    SELECT saldo FROM Cuentas WHERE id_cuenta = @id_cuenta;
END;
GO

CREATE PROCEDURE spu_MovimientoCuenta
@fecha_movimiento DATETIME
AS
BEGIN
    SELECT c.apellido_cli, m.id_movimiento, m.saldo_ant, m.saldo_post,
           m.importe, m.fecha_mov
    FROM Movimientos m
    INNER JOIN Cuentas cu ON m.id_cuenta = cu.id_cuenta
    INNER JOIN Clientes c ON cu.id_cliente = c.id_cliente
    WHERE m.fecha_mov = @fecha_movimiento
    ORDER BY m.fecha_mov DESC
END;
GO

-----------------------------------------------------------------------

EXEC spd_addClientes
    @id_cliente = 3,
    @apellido_cli = 'Lopez',
    @nombre_cli = 'Pedro',
    @dni = '25673333',
    @telefono = '4355866',
    @fecha_nac = '1960-11-20';

EXEC spd_addCuentas
    @id_cuenta = 10,
    @id_cliente = 3,
    @saldo = 10000.00;

EXEC spd_addMovimientos
    @id_movimiento = 1,
    @id_cuenta = 10,
    @saldo_ant = 10000.00,
    @saldo_post = 9500.00,
    @importe = -500.00,
    @fecha_mov = '2008-05-02';

-----------------------------------------------------------------------

EXEC spd_addClientes
    @id_cliente = 1,
    @apellido_cli = 'Gomez',
    @nombre_cli = 'Laura',
    @dni = '30222444',
    @telefono = '1133445566',
    @fecha_nac = '1985-07-15';

EXEC spd_addCuentas
    @id_cuenta = 100,
    @id_cliente = 1,
    @saldo = 5000.00;

EXEC spd_addMovimientos
    @id_movimiento = 1000,
    @id_cuenta = 100,
    @saldo_ant = 5000.00,
    @saldo_post = 4500.00,
    @importe = -500.00,
    @fecha_mov = '2025-06-10';

EXEC spu_ObtenerSaldoCuenta @id_cuenta = 100;

EXEC spu_MovimientoCuenta @fecha_movimiento = '2025-06-10';
