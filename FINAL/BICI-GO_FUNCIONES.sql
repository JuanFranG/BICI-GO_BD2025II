

-- =====================================================
-- FUNCIÓN 1: CALCULAR DURACIÓN DE ALQUILER EN HORAS
-- =====================================================
-- Tipo: Función escalar
-- Descripción: Calcula las horas entre inicio y fin de alquiler

CREATE FUNCTION fn_CalcularHorasAlquiler
(
    @fecha_inicio DATETIME,
    @fecha_fin DATETIME
)
RETURNS INT
AS
BEGIN
    DECLARE @horas INT;
    
    -- Si no hay fecha fin, usar fecha actual
    IF @fecha_fin IS NULL
        SET @horas = DATEDIFF(HOUR, @fecha_inicio, GETDATE());
    ELSE
        SET @horas = DATEDIFF(HOUR, @fecha_inicio, @fecha_fin);
    
    RETURN @horas;
END;
GO

PRINT 'Función 1 creada: fn_CalcularHorasAlquiler';
GO

-- =====================================================
-- FUNCIÓN 2: CALCULAR COSTO POR HORAS
-- =====================================================
-- Tipo: Función escalar
-- Descripción: Calcula el costo según horas y tarifa por hora

CREATE FUNCTION fn_CalcularCostoPorHoras
(
    @horas INT,
    @tarifa_hora DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @costo DECIMAL(10,2);
    
    -- Calcular costo base
    SET @costo = @horas * @tarifa_hora;
    
    -- Aplicar descuento si son más de 24 horas (día completo)
    IF @horas >= 24
        SET @costo = @costo * 0.85; -- 15% descuento
    
    RETURN @costo;
END;
GO

PRINT 'Función 2 creada: fn_CalcularCostoPorHoras';
GO

-- =====================================================
-- FUNCIÓN 3: OBTENER ESTADO DE BICICLETA POR USO
-- =====================================================
-- Tipo: Función escalar
-- Descripción: Determina el estado recomendado según kilometraje

CREATE FUNCTION fn_EstadoBicicletaPorUso
(
    @kilometraje INT,
    @horas_uso DECIMAL(10,2)
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @estado VARCHAR(50);
    
    IF @kilometraje >= 300 OR @horas_uso >= 50
        SET @estado = 'REQUIERE MANTENIMIENTO MAYOR';
    ELSE IF @kilometraje >= 200 OR @horas_uso >= 30
        SET @estado = 'REQUIERE REVISIÓN';
    ELSE IF @kilometraje >= 100 OR @horas_uso >= 15
        SET @estado = 'EN BUEN ESTADO';
    ELSE
        SET @estado = 'COMO NUEVA';
    
    RETURN @estado;
END;
GO

PRINT 'Función 3 creada: fn_EstadoBicicletaPorUso';
GO

-- =====================================================
-- FUNCIÓN 4: CALCULAR DESCUENTO POR CLIENTE FRECUENTE
-- =====================================================
-- Tipo: Función escalar
-- Descripción: Calcula porcentaje de descuento según historial

CREATE FUNCTION fn_CalcularDescuentoFrecuente
(
    @id_turista INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @descuento DECIMAL(5,2);
    DECLARE @total_alquileres INT;
    
    -- Contar alquileres del turista
    SELECT @total_alquileres = COUNT(*)
    FROM Alquiler
    WHERE id_turista = @id_turista;
    
    -- Aplicar descuento según cantidad
    IF @total_alquileres >= 10
        SET @descuento = 20.00; -- 20%
    ELSE IF @total_alquileres >= 5
        SET @descuento = 10.00; -- 10%
    ELSE IF @total_alquileres >= 3
        SET @descuento = 5.00;  -- 5%
    ELSE
        SET @descuento = 0.00;
    
    RETURN @descuento;
END;
GO

PRINT 'Función 4 creada: fn_CalcularDescuentoFrecuente';
GO

-- =====================================================
-- FUNCIÓN 5: FORMATEAR NOMBRE COMPLETO
-- =====================================================
-- Tipo: Función escalar
-- Descripción: Formatea email a nombre legible

CREATE FUNCTION fn_FormatearNombreDesdeEmail
(
    @email VARCHAR(100)
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @nombre VARCHAR(100);
    DECLARE @parte_nombre VARCHAR(100);
    
    -- Extraer la parte antes del @
    SET @parte_nombre = LEFT(@email, CHARINDEX('@', @email) - 1);
    
    -- Reemplazar puntos y guiones por espacios
    SET @parte_nombre = REPLACE(@parte_nombre, '.', ' ');
    SET @parte_nombre = REPLACE(@parte_nombre, '-', ' ');
    SET @parte_nombre = REPLACE(@parte_nombre, '_', ' ');
    
    -- Primera letra mayúscula de cada palabra (simplificado)
    SET @nombre = UPPER(LEFT(@parte_nombre, 1)) + LOWER(SUBSTRING(@parte_nombre, 2, LEN(@parte_nombre)));
    
    RETURN @nombre;
END;
GO

PRINT 'Función 5 creada: fn_FormatearNombreDesdeEmail';
GO

-- =====================================================
-- FUNCIÓN 6: OBTENER BICICLETAS DISPONIBLES POR PUNTO
-- =====================================================
-- Tipo: Función de tabla en línea (Table-Valued Function)
-- Descripción: Retorna bicicletas disponibles de un punto

CREATE FUNCTION fn_BicicletasDisponiblesPorPunto
(
    @id_punto_alquiler INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        B.id_bicicleta,
        B.Marca,
        B.Modelo,
        B.Tamaño_del_Marco,
        TT.nombre AS tipo_terreno,
        TA.nombre AS tipo_asistencia,
        EF.nombre AS estado_fisico,
        B.Kilometraje,
        B.Horas_Uso
    FROM Bicicleta B
        INNER JOIN tipo_terreno TT ON B.id_terreno = TT.id_terreno
        INNER JOIN Tipo_Asistencia TA ON B.id_tipo_asistencia = TA.id_tipo_asistencia
        INNER JOIN estado_Fisico_Bicicleta EF ON B.id_estado_fisico_bicicleta = EF.id_estado_fisico_bicicleta
        INNER JOIN Disponibilidad_bicicleta DB ON B.id_disponibilidad = DB.id_disponibilidad
    WHERE B.id_punto_de_alquiler = @id_punto_alquiler
      AND DB.nombre = 'Disponible'
);
GO

PRINT 'Función 6 creada: fn_BicicletasDisponiblesPorPunto';
GO

-- =====================================================
-- FUNCIÓN 7: OBTENER HISTORIAL DE TURISTA
-- =====================================================
-- Tipo: Función de tabla en línea
-- Descripción: Retorna historial completo de un turista

CREATE FUNCTION fn_HistorialTurista
(
    @id_turista INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        A.id_alquiler,
        A.fecha_inicio,
        A.fecha_Fin,
        B.Marca + ' ' + B.Modelo AS bicicleta,
        P.Nombre AS punto_alquiler,
        PL.nombre AS plan_nombre,
        PG.monto,
        DATEDIFF(HOUR, A.fecha_inicio, ISNULL(A.fecha_Fin, GETDATE())) AS horas_uso
    FROM Alquiler A
        INNER JOIN Bicicleta B ON A.id_bicicleta = B.id_bicicleta
        INNER JOIN Punto_de_Alquiler P ON A.id_punto_de_alquiler = P.id_punto_de_alquiler
        INNER JOIN Plan_De_Alquiler PL ON A.id_plan = PL.id_plan
        INNER JOIN Pago PG ON A.id_alquiler = PG.id_alquiler
    WHERE A.id_turista = @id_turista
);
GO

PRINT 'Función 7 creada: fn_HistorialTurista';
GO

-- =====================================================
-- FUNCIÓN 8: CALCULAR ESTADÍSTICAS DE PUNTO
-- =====================================================
-- Tipo: Función de tabla en línea (simplificada)
-- Descripción: Retorna estadísticas básicas de un punto

CREATE FUNCTION fn_EstadisticasPunto
(
    @id_punto_alquiler INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        P.Nombre AS nombre_punto,
        COUNT(DISTINCT B.id_bicicleta) AS total_bicicletas,
        COUNT(DISTINCT A.id_alquiler) AS total_alquileres,
        SUM(PG.monto) AS ingresos_totales,
        AVG(PG.monto) AS ingreso_promedio,
        COUNT(DISTINCT E.id_empleado) AS total_empleados
    FROM Punto_de_Alquiler P
        LEFT JOIN Bicicleta B ON P.id_punto_de_alquiler = B.id_punto_de_alquiler
        LEFT JOIN Alquiler A ON P.id_punto_de_alquiler = A.id_punto_de_alquiler
        LEFT JOIN Pago PG ON A.id_alquiler = PG.id_alquiler
        LEFT JOIN empleado E ON P.id_punto_de_alquiler = E.id_punto_de_alquiler
    WHERE P.id_punto_de_alquiler = @id_punto_alquiler
    GROUP BY P.id_punto_de_alquiler, P.Nombre
);
GO

PRINT 'Función 8 creada: fn_EstadisticasPunto';
GO

-- =====================================================
-- FUNCIÓN 9: OBTENER TARIFAS VIGENTES DE UN PLAN
-- =====================================================
-- Tipo: Función de tabla en línea
-- Descripción: Retorna tarifas activas de un plan específico

CREATE FUNCTION fn_TarifasVigentesPlan
(
    @id_plan INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        P.nombre AS plan_nombre,
        D.nombre AS duracion,
        T.precio,
        M.codigo AS moneda_codigo,
        M.simbolo AS moneda_simbolo,
        T.fecha_Inicio,
        T.fecha_Fin
    FROM Tarifa T
        INNER JOIN Plan_De_Alquiler P ON T.id_plan = P.id_plan
        INNER JOIN Duracion D ON T.id_duracion = D.id_duracion
        INNER JOIN Moneda M ON T.id_moneda = M.id_moneda
    WHERE T.id_plan = @id_plan
      AND T.estado_Plan = 1
      AND GETDATE() BETWEEN T.fecha_Inicio AND ISNULL(T.fecha_Fin, '2099-12-31')
);
GO

PRINT 'Función 9 creada: fn_TarifasVigentesPlan';
GO

-- =====================================================
-- FUNCIÓN 10: GENERAR REPORTE DE BICICLETA
-- =====================================================
-- Tipo: Función de tabla multi-statement
-- Descripción: Reporte completo de una bicicleta con su historial

CREATE FUNCTION fn_ReporteBicicleta
(
    @id_bicicleta INT
)
RETURNS @Reporte TABLE
(
    seccion VARCHAR(50),
    etiqueta VARCHAR(100),
    valor VARCHAR(200)
)
AS
BEGIN
    -- Información básica
    INSERT INTO @Reporte
    SELECT 'Información Básica', 'ID Bicicleta', CAST(@id_bicicleta AS VARCHAR(200))
    UNION ALL
    SELECT 'Información Básica', 'Marca', Marca FROM Bicicleta WHERE id_bicicleta = @id_bicicleta
    UNION ALL
    SELECT 'Información Básica', 'Modelo', Modelo FROM Bicicleta WHERE id_bicicleta = @id_bicicleta
    UNION ALL
    SELECT 'Información Básica', 'Tamaño Marco', Tamaño_del_Marco FROM Bicicleta WHERE id_bicicleta = @id_bicicleta;
    
    -- Estadísticas de uso
    INSERT INTO @Reporte
    SELECT 'Uso', 'Kilometraje', CAST(Kilometraje AS VARCHAR(200))
    FROM Bicicleta WHERE id_bicicleta = @id_bicicleta
    UNION ALL
    SELECT 'Uso', 'Horas de Uso', CAST(Horas_Uso AS VARCHAR(200))
    FROM Bicicleta WHERE id_bicicleta = @id_bicicleta
    UNION ALL
    SELECT 'Uso', 'Veces Alquilada', CAST(COUNT(*) AS VARCHAR(200))
    FROM Alquiler WHERE id_bicicleta = @id_bicicleta;
    
    -- Calificación
    INSERT INTO @Reporte
    SELECT 'Calificación', 'Promedio', CAST(AVG(calificacion) AS VARCHAR(200))
    FROM Reseña WHERE id_bicicleta = @id_bicicleta
    UNION ALL
    SELECT 'Calificación', 'Total Reseñas', CAST(COUNT(*) AS VARCHAR(200))
    FROM Reseña WHERE id_bicicleta = @id_bicicleta;
    
    RETURN;
END;
GO

PRINT 'Función 10 creada: fn_ReporteBicicleta';
GO

-- =====================================================
-- PRUEBAS DE LAS FUNCIONES
-- =====================================================



-- Prueba 1: Calcular horas
PRINT 'Prueba 1: Calcular horas de alquiler';
SELECT dbo.fn_CalcularHorasAlquiler('2024-11-01 09:00', '2024-11-01 17:00') AS horas_alquiler;
GO

-- Prueba 2: Calcular costo
PRINT 'Prueba 2: Calcular costo por horas';
SELECT dbo.fn_CalcularCostoPorHoras(8, 8000) AS costo_total;
GO

-- Prueba 3: Estado de bicicleta
PRINT 'Prueba 3: Determinar estado de bicicleta';
SELECT dbo.fn_EstadoBicicletaPorUso(250, 35) AS estado_recomendado;
GO

-- Prueba 4: Descuento cliente frecuente
PRINT 'Prueba 4: Calcular descuento por cliente frecuente';
SELECT dbo.fn_CalcularDescuentoFrecuente(1) AS descuento_porcentaje;
GO

-- Prueba 5: Formatear nombre
PRINT 'Prueba 5: Formatear nombre desde email';
SELECT dbo.fn_FormatearNombreDesdeEmail('carlos.rodriguez@email.com') AS nombre_formateado;
GO

-- Prueba 6: Bicicletas disponibles
PRINT 'Prueba 6: Bicicletas disponibles en punto 1';
SELECT * FROM dbo.fn_BicicletasDisponiblesPorPunto(1);
GO

-- Prueba 7: Historial de turista
PRINT 'Prueba 7: Historial de turista 1';
SELECT * FROM dbo.fn_HistorialTurista(1);
GO

-- Prueba 8: Estadísticas de punto
PRINT 'Prueba 8: Estadísticas del punto 1';
SELECT * FROM dbo.fn_EstadisticasPunto(1);
GO

-- Prueba 9: Tarifas vigentes
PRINT 'Prueba 9: Tarifas vigentes del plan 1';
SELECT * FROM dbo.fn_TarifasVigentesPlan(1);
GO

-- Prueba 10: Reporte de bicicleta
PRINT 'Prueba 10: Reporte completo de bicicleta 1';
SELECT * FROM dbo.fn_ReporteBicicleta(1);
GO
