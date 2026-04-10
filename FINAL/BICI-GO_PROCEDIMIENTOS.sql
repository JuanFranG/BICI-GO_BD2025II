
-- =====================================================
-- PROCEDIMIENTO 1: REGISTRAR TURISTA
-- =====================================================
-- Inserta un nuevo turista en el sistema

CREATE PROCEDURE sp_RegistrarTurista
    @email VARCHAR(100),
    @contraseña VARCHAR(255),
    @documento VARCHAR(50),
    @fecha_nacimiento DATE,
    @telefono VARCHAR(20),
    @id_tipo_documento INT,
    @pais_procedente VARCHAR(100)
AS
BEGIN
    -- Insertar usuario
    INSERT INTO Usuario (email, contraseña, documento_identidad, fecha_registro, 
                       fecha_nacimiento, telefono, id_tipo_documento_identidad)
    VALUES (@email, @contraseña, @documento, GETDATE(), 
            @fecha_nacimiento, @telefono, @id_tipo_documento);
    
    -- Obtener ID generado
    DECLARE @id_nuevo INT = SCOPE_IDENTITY();
    
    -- Insertar turista
    INSERT INTO Turista (id_turista, pais_procedente)
    VALUES (@id_nuevo, @pais_procedente);
    
    PRINT 'Turista registrado con ID: ' + CAST(@id_nuevo AS VARCHAR(10));
END;
GO

PRINT 'Procedimiento 1 creado: sp_RegistrarTurista';
GO

-- =====================================================
-- PROCEDIMIENTO 2: INICIAR ALQUILER
-- =====================================================
-- Crea un nuevo alquiler

CREATE PROCEDURE sp_IniciarAlquiler
    @id_turista INT,
    @id_bicicleta INT,
    @id_punto INT,
    @id_plan INT
AS
BEGIN
    -- Crear alquiler
    INSERT INTO Alquiler (fecha_inicio, id_turista, id_bicicleta, id_punto_de_alquiler, id_plan)
    VALUES (GETDATE(), @id_turista, @id_bicicleta, @id_punto, @id_plan);
    
    DECLARE @id_alquiler INT = SCOPE_IDENTITY();
    
    -- Cambiar estado bicicleta
    UPDATE Bicicleta
    SET id_disponibilidad = 2  -- 2 = En Alquiler
    WHERE id_bicicleta = @id_bicicleta;
    
    PRINT 'Alquiler creado: ' + CAST(@id_alquiler AS VARCHAR(10));
END;
GO

PRINT 'Procedimiento 2 creado: sp_IniciarAlquiler';
GO

-- =====================================================
-- PROCEDIMIENTO 3: FINALIZAR ALQUILER
-- =====================================================
-- Termina un alquiler activo

CREATE PROCEDURE sp_FinalizarAlquiler
    @id_alquiler INT
AS
BEGIN
    DECLARE @id_bici INT;
    
    -- Obtener bicicleta
    SELECT @id_bici = id_bicicleta FROM Alquiler WHERE id_alquiler = @id_alquiler;
    
    -- Finalizar alquiler
    UPDATE Alquiler
    SET fecha_Fin = GETDATE()
    WHERE id_alquiler = @id_alquiler;
    
    -- Liberar bicicleta
    UPDATE Bicicleta
    SET id_disponibilidad = 1  -- 1 = Disponible
    WHERE id_bicicleta = @id_bici;
    
    PRINT 'Alquiler finalizado';
END;
GO

PRINT 'Procedimiento 3 creado: sp_FinalizarAlquiler';
GO

-- =====================================================
-- PROCEDIMIENTO 4: REGISTRAR PAGO
-- =====================================================
-- Registra un pago de alquiler

CREATE PROCEDURE sp_RegistrarPago
    @id_alquiler INT,
    @monto DECIMAL(10,2),
    @id_tipo_pago INT
AS
BEGIN
    INSERT INTO Pago (Fecha, id_tipo_pago, id_alquiler, monto)
    VALUES (GETDATE(), @id_tipo_pago, @id_alquiler, @monto);
    
    PRINT 'Pago registrado: $' + CAST(@monto AS VARCHAR(20));
END;
GO

PRINT 'Procedimiento 4 creado: sp_RegistrarPago';
GO

-- =====================================================
-- PROCEDIMIENTO 5: AGREGAR RESEÑA
-- =====================================================
-- Permite agregar una reseña

CREATE PROCEDURE sp_AgregarReseña
    @id_turista INT,
    @id_bicicleta INT,
    @calificacion DECIMAL(3,2),
    @comentario TEXT
AS
BEGIN
    INSERT INTO Reseña (calificacion, fecha, comentario, id_turista, id_bicicleta)
    VALUES (@calificacion, GETDATE(), @comentario, @id_turista, @id_bicicleta);
    
    PRINT 'Reseña agregada con calificación: ' + CAST(@calificacion AS VARCHAR(5));
END;
GO

PRINT 'Procedimiento 5 creado: sp_AgregarReseña';
GO

-- =====================================================
-- PROCEDIMIENTO 6: BUSCAR BICICLETAS DISPONIBLES
-- =====================================================
-- Lista bicicletas disponibles en un punto

CREATE PROCEDURE sp_BuscarBicicletasDisponibles
    @id_punto INT
AS
BEGIN
    SELECT 
        B.id_bicicleta,
        B.Marca,
        B.Modelo,
        TT.nombre AS tipo_terreno,
        TA.nombre AS tipo_asistencia
    FROM Bicicleta B
        INNER JOIN tipo_terreno TT ON B.id_terreno = TT.id_terreno
        INNER JOIN Tipo_Asistencia TA ON B.id_tipo_asistencia = TA.id_tipo_asistencia
        INNER JOIN Disponibilidad_bicicleta D ON B.id_disponibilidad = D.id_disponibilidad
    WHERE B.id_punto_de_alquiler = @id_punto
      AND D.nombre = 'Disponible';
END;
GO

PRINT 'Procedimiento 6 creado: sp_BuscarBicicletasDisponibles';
GO

-- =====================================================
-- PROCEDIMIENTO 7: CONSULTAR ALQUILERES TURISTA
-- =====================================================
-- Muestra historial de alquileres

CREATE PROCEDURE sp_ConsultarAlquileresTurista
    @id_turista INT
AS
BEGIN
    SELECT 
        A.id_alquiler,
        A.fecha_inicio,
        A.fecha_Fin,
        B.Marca + ' ' + B.Modelo AS bicicleta,
        P.Nombre AS punto
    FROM Alquiler A
        INNER JOIN Bicicleta B ON A.id_bicicleta = B.id_bicicleta
        INNER JOIN Punto_de_Alquiler P ON A.id_punto_de_alquiler = P.id_punto_de_alquiler
    WHERE A.id_turista = @id_turista
    ORDER BY A.fecha_inicio DESC;
END;
GO

PRINT 'Procedimiento 7 creado: sp_ConsultarAlquileresTurista';
GO

-- =====================================================
-- PROCEDIMIENTO 8: ACTUALIZAR KILOMETRAJE
-- =====================================================
-- Actualiza kilometraje de una bicicleta

CREATE PROCEDURE sp_ActualizarKilometraje
    @id_bicicleta INT,
    @km_adicional INT
AS
BEGIN
    UPDATE Bicicleta
    SET Kilometraje = Kilometraje + @km_adicional
    WHERE id_bicicleta = @id_bicicleta;
    
    PRINT 'Kilometraje actualizado: +' + CAST(@km_adicional AS VARCHAR(10)) + ' km';
END;
GO

PRINT 'Procedimiento 8 creado: sp_ActualizarKilometraje';
GO

-- =====================================================
-- PROCEDIMIENTO 9: REPORTE MENSUAL SIMPLE
-- =====================================================
-- Genera reporte básico del mes

CREATE PROCEDURE sp_ReporteMensual
    @mes INT,
    @año INT
AS
BEGIN
    SELECT 
        COUNT(*) AS total_alquileres,
        SUM(P.monto) AS ingresos_totales,
        AVG(P.monto) AS ingreso_promedio
    FROM Alquiler A
        INNER JOIN Pago P ON A.id_alquiler = P.id_alquiler
    WHERE MONTH(A.fecha_inicio) = @mes
      AND YEAR(A.fecha_inicio) = @año;
END;
GO

PRINT 'Procedimiento 9 creado: sp_ReporteMensual';
GO

-- =====================================================
-- PROCEDIMIENTO 10: LISTAR PUNTOS DE ALQUILER
-- =====================================================
-- Muestra todos los puntos disponibles

CREATE PROCEDURE sp_ListarPuntosAlquiler
AS
BEGIN
    SELECT 
        P.id_punto_de_alquiler,
        P.Nombre,
        C.Nombre AS ciudad,
        D.Nombre AS departamento,
        COUNT(B.id_bicicleta) AS total_bicicletas
    FROM Punto_de_Alquiler P
        INNER JOIN Ciudad C ON P.id_ciudad = C.id_ciudad
        INNER JOIN Departamento D ON C.id_departamento = D.id_departamento
        LEFT JOIN Bicicleta B ON P.id_punto_de_alquiler = B.id_punto_de_alquiler
    GROUP BY P.id_punto_de_alquiler, P.Nombre, C.Nombre, D.Nombre;
END;
GO

PRINT 'Procedimiento 10 creado: sp_ListarPuntosAlquiler';
GO

-- =====================================================
-- PRUEBAS BÁSICAS
-- =====================================================

PRINT '';
PRINT '=== PRUEBAS DE PROCEDIMIENTOS ===';
PRINT '';

-- Prueba 6
PRINT 'Probando: Buscar bicicletas disponibles';
EXEC sp_BuscarBicicletasDisponibles @id_punto = 1;
GO

-- Prueba 7
PRINT 'Probando: Consultar alquileres de turista';
EXEC sp_ConsultarAlquileresTurista @id_turista = 1;
GO

-- Prueba 9
PRINT 'Probando: Reporte mensual';
EXEC sp_ReporteMensual @mes = 11, @año = 2024;
GO

-- Prueba 10
PRINT 'Probando: Listar puntos';
EXEC sp_ListarPuntosAlquiler;
GO


