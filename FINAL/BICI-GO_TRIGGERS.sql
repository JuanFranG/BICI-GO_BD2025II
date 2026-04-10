
-- =====================================================
-- TRIGGER 1: VALIDAR EMAIL AL INSERTAR USUARIO
-- =====================================================
-- Verifica que el email tenga formato válido

CREATE TRIGGER tr_ValidarEmail
ON Usuario
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE email NOT LIKE '%@%')
    BEGIN
        RAISERROR('Email debe contener @', 16, 1);
        ROLLBACK;
    END
END;
GO

PRINT 'Trigger 1 creado: tr_ValidarEmail';
GO

-- =====================================================
-- TRIGGER 2: ACTUALIZAR KILOMETRAJE AL FINALIZAR
-- =====================================================
-- Suma kilometraje cuando termina un alquiler

CREATE TRIGGER tr_ActualizarKilometraje
ON Alquiler
AFTER UPDATE
AS
BEGIN
    IF UPDATE(fecha_Fin)
    BEGIN
        UPDATE B
        SET Kilometraje = Kilometraje + 50  -- 50 km por alquiler
        FROM Bicicleta B
        INNER JOIN inserted I ON B.id_bicicleta = I.id_bicicleta
        WHERE I.fecha_Fin IS NOT NULL;
    END
END;
GO

PRINT 'Trigger 2 creado: tr_ActualizarKilometraje';
GO

-- =====================================================
-- TRIGGER 3: VALIDAR CALIFICACIÓN
-- =====================================================
-- Verifica que calificación esté entre 1 y 5

CREATE TRIGGER tr_ValidarCalificacion
ON Reseña
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE calificacion < 1 OR calificacion > 5)
    BEGIN
        RAISERROR('Calificación debe estar entre 1 y 5', 16, 1);
        ROLLBACK;
    END
END;
GO

PRINT 'Trigger 3 creado: tr_ValidarCalificacion';
GO

-- =====================================================
-- TRIGGER 4: REGISTRAR FECHA DE RESEÑA
-- =====================================================
-- Asegura que la reseña tenga fecha actual

CREATE TRIGGER tr_FechaReseña
ON Reseña
AFTER INSERT
AS
BEGIN
    UPDATE Reseña
    SET fecha = GETDATE()
    WHERE id_reseña IN (SELECT id_reseña FROM inserted WHERE fecha IS NULL);
END;
GO

PRINT 'Trigger 4 creado: tr_FechaReseña';
GO

-- =====================================================
-- TRIGGER 5: CAMBIAR ESTADO AL CREAR ALQUILER
-- =====================================================
-- Cambia bicicleta a "En Alquiler"

CREATE TRIGGER tr_CambiarEstadoAlquiler
ON Alquiler
AFTER INSERT
AS
BEGIN
    UPDATE Bicicleta
    SET id_disponibilidad = 2  -- En Alquiler
    WHERE id_bicicleta IN (SELECT id_bicicleta FROM inserted);
END;
GO

PRINT 'Trigger 5 creado: tr_CambiarEstadoAlquiler';
GO

-- =====================================================
-- TRIGGER 6: LIBERAR BICICLETA AL FINALIZAR
-- =====================================================
-- Cambia bicicleta a "Disponible"

CREATE TRIGGER tr_LiberarBicicleta
ON Alquiler
AFTER UPDATE
AS
BEGIN
    IF UPDATE(fecha_Fin)
    BEGIN
        UPDATE B
        SET id_disponibilidad = 1  -- Disponible
        FROM Bicicleta B
        INNER JOIN inserted I ON B.id_bicicleta = I.id_bicicleta
        WHERE I.fecha_Fin IS NOT NULL;
    END
END;
GO

PRINT 'Trigger 6 creado: tr_LiberarBicicleta';
GO

-- =====================================================
-- TRIGGER 7: VALIDAR MONTO PAGO
-- =====================================================
-- Verifica que el monto sea positivo

CREATE TRIGGER tr_ValidarMontoPago
ON Pago
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE monto <= 0)
    BEGIN
        RAISERROR('El monto debe ser mayor a cero', 16, 1);
        ROLLBACK;
    END
END;
GO

PRINT 'Trigger 7 creado: tr_ValidarMontoPago';
GO

-- =====================================================
-- TRIGGER 8: REGISTRAR FECHA DE PAGO
-- =====================================================
-- Asegura que el pago tenga fecha

CREATE TRIGGER tr_FechaPago
ON Pago
AFTER INSERT
AS
BEGIN
    UPDATE Pago
    SET Fecha = GETDATE()
    WHERE id_pago IN (SELECT id_pago FROM inserted WHERE Fecha IS NULL);
END;
GO

PRINT 'Trigger 8 creado: tr_FechaPago';
GO

-- =====================================================
-- TRIGGER 9: VALIDAR FECHA NACIMIENTO
-- =====================================================
-- Verifica que el usuario sea mayor de 18 años

CREATE TRIGGER tr_ValidarEdad
ON Usuario
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted 
        WHERE DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) < 18
    )
    BEGIN
        RAISERROR('El usuario debe ser mayor de 18 años', 16, 1);
        ROLLBACK;
    END
END;
GO

PRINT 'Trigger 9 creado: tr_ValidarEdad';
GO

-- =====================================================
-- TRIGGER 10: INCREMENTAR HORAS DE USO
-- =====================================================
-- Suma horas cuando finaliza alquiler

CREATE TRIGGER tr_IncrementarHoras
ON Alquiler
AFTER UPDATE
AS
BEGIN
    IF UPDATE(fecha_Fin)
    BEGIN
        DECLARE @horas INT;
        
        SELECT @horas = DATEDIFF(HOUR, I.fecha_inicio, I.fecha_Fin)
        FROM inserted I
        WHERE I.fecha_Fin IS NOT NULL;
        
        UPDATE B
        SET Horas_Uso = Horas_Uso + @horas
        FROM Bicicleta B
        INNER JOIN inserted I ON B.id_bicicleta = I.id_bicicleta
        WHERE I.fecha_Fin IS NOT NULL;
    END
END;
GO

PRINT 'Trigger 10 creado: tr_IncrementarHoras';
GO

