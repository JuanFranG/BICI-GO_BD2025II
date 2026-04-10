
CREATE VIEW v_Alquileres_Basico AS
SELECT 
    A.id_alquiler,
    A.fecha_inicio,
    A.fecha_Fin,
    U.email AS turista_email,
    B.Marca AS bicicleta_marca,
    B.Modelo AS bicicleta_modelo,
    P.Nombre AS punto_alquiler
FROM Alquiler A
INNER JOIN Turista T ON A.id_turista = T.id_turista
INNER JOIN Usuario U ON T.id_turista = U.id_usuario
INNER JOIN Bicicleta B ON A.id_bicicleta = B.id_bicicleta
INNER JOIN Punto_de_Alquiler P ON A.id_punto_de_alquiler = P.id_punto_de_alquiler;
GO

PRINT 'Vista 1 creada: v_Alquileres_Basico';
GO

-- =====================================================
-- VISTA 2: AGREGACIONES DE INGRESOS POR PUNTO
-- =====================================================
-- Competencia: Funciones de agregación (COUNT, SUM, AVG)
-- Descripción: Resumen de ingresos y alquileres por punto

CREATE VIEW v_Ingresos_Por_Punto AS
SELECT 
    P.id_punto_de_alquiler,
    P.Nombre AS punto_alquiler,
    C.Nombre AS ciudad,
    COUNT(A.id_alquiler) AS total_alquileres,
    SUM(PG.monto) AS ingresos_totales,
    AVG(PG.monto) AS ingreso_promedio,
    MIN(PG.monto) AS ingreso_minimo,
    MAX(PG.monto) AS ingreso_maximo
FROM Punto_de_Alquiler P
INNER JOIN Ciudad C ON P.id_ciudad = C.id_ciudad
LEFT JOIN Alquiler A ON P.id_punto_de_alquiler = A.id_punto_de_alquiler
LEFT JOIN Pago PG ON A.id_alquiler = PG.id_alquiler
GROUP BY P.id_punto_de_alquiler, P.Nombre, C.Nombre;
GO

PRINT 'Vista 2 creada: v_Ingresos_Por_Punto';
GO

-- =====================================================
-- VISTA 3: BICICLETAS CON SUBCONSULTA AUTÓNOMA
-- =====================================================
-- Competencia: Subconsultas autónomas
-- Descripción: Bicicletas con uso superior al promedio

CREATE VIEW v_Bicicletas_Alto_Uso AS
SELECT 
    B.id_bicicleta,
    B.Marca,
    B.Modelo,
    B.Kilometraje,
    B.Horas_Uso,
    P.Nombre AS punto_alquiler,
    (SELECT AVG(Kilometraje) FROM Bicicleta) AS kilometraje_promedio,
    (SELECT AVG(Horas_Uso) FROM Bicicleta) AS horas_promedio
FROM Bicicleta B
INNER JOIN Punto_de_Alquiler P ON B.id_punto_de_alquiler = P.id_punto_de_alquiler
WHERE B.Kilometraje > (SELECT AVG(Kilometraje) FROM Bicicleta)
   OR B.Horas_Uso > (SELECT AVG(Horas_Uso) FROM Bicicleta);
GO

PRINT 'Vista 3 creada: v_Bicicletas_Alto_Uso';
GO

-- =====================================================
-- VISTA 4: TURISTAS CON SUBCONSULTA CORRELACIONADA
-- =====================================================
-- Competencia: Subconsultas correlacionadas
-- Descripción: Turistas con su último alquiler

CREATE VIEW v_Turistas_Ultimo_Alquiler AS
SELECT 
    U.id_usuario,
    U.email,
    T.pais_procedente,
    (SELECT MAX(A.fecha_inicio)
     FROM Alquiler A
     WHERE A.id_turista = T.id_turista) AS fecha_ultimo_alquiler,
    (SELECT COUNT(*)
     FROM Alquiler A
     WHERE A.id_turista = T.id_turista) AS total_alquileres
FROM Usuario U
INNER JOIN Turista T ON U.id_usuario = T.id_turista;
GO

PRINT 'Vista 4 creada: v_Turistas_Ultimo_Alquiler';
GO

-- =====================================================
-- VISTA 5: COMBINACIÓN EXTERNA IZQUIERDA (LEFT JOIN)
-- =====================================================
-- Competencia: LEFT JOIN
-- Descripción: Todas las bicicletas con o sin reseñas

CREATE VIEW v_Bicicletas_Con_Sin_Reseñas AS
SELECT 
    B.id_bicicleta,
    B.Marca,
    B.Modelo,
    P.Nombre AS punto_alquiler,
    COUNT(R.id_reseña) AS cantidad_reseñas,
    AVG(R.calificacion) AS calificacion_promedio,
    CASE 
        WHEN COUNT(R.id_reseña) = 0 THEN 'Sin reseñas'
        WHEN AVG(R.calificacion) >= 4.5 THEN 'Excelente'
        WHEN AVG(R.calificacion) >= 3.5 THEN 'Buena'
        ELSE 'Regular'
    END AS categoria_calificacion
FROM Bicicleta B
INNER JOIN Punto_de_Alquiler P ON B.id_punto_de_alquiler = P.id_punto_de_alquiler
LEFT JOIN Reseña R ON B.id_bicicleta = R.id_bicicleta
GROUP BY B.id_bicicleta, B.Marca, B.Modelo, P.Nombre;
GO

PRINT 'Vista 5 creada: v_Bicicletas_Con_Sin_Reseñas';
GO

-- =====================================================
-- VISTA 6: COMBINACIÓN EXTERNA DERECHA (RIGHT JOIN)
-- =====================================================
-- Competencia: RIGHT JOIN
-- Descripción: Todos los planes con o sin alquileres

CREATE VIEW v_Planes_Con_Sin_Alquileres AS
SELECT 
    PL.id_plan,
    PL.nombre AS plan_nombre,
    COUNT(A.id_alquiler) AS veces_contratado,
    SUM(P.monto) AS ingresos_generados,
    CASE 
        WHEN COUNT(A.id_alquiler) = 0 THEN 'No contratado'
        WHEN COUNT(A.id_alquiler) < 3 THEN 'Bajo uso'
        ELSE 'Popular'
    END AS nivel_popularidad
FROM Alquiler A
INNER JOIN Pago P ON A.id_alquiler = P.id_alquiler
RIGHT JOIN Plan_De_Alquiler PL ON A.id_plan = PL.id_plan
GROUP BY PL.id_plan, PL.nombre;  -- ✅ Sin descripcion
GO

PRINT 'Vista 6 creada: v_Planes_Con_Sin_Alquileres';
GO

-- =====================================================
-- VISTA 7: OPERACIÓN DE CONJUNTO (UNION)
-- =====================================================
-- Competencia: Operaciones de conjunto
-- Descripción: Todos los usuarios (turistas y administradores)

CREATE VIEW v_Todos_Usuarios_Unificados AS
SELECT 
    U.id_usuario,
    U.email,
    U.documento_identidad,
    'Turista' AS tipo_usuario,
    T.pais_procedente AS informacion_adicional
FROM Usuario U
INNER JOIN Turista T ON U.id_usuario = T.id_turista
UNION
SELECT 
    U.id_usuario,
    U.email,
    U.documento_identidad,
    'Administrador' AS tipo_usuario,
    A.cargo AS informacion_adicional
FROM Usuario U
INNER JOIN Administrador A ON U.id_usuario = A.id_administrador;
GO

PRINT 'Vista 7 creada: v_Todos_Usuarios_Unificados';
GO

-- =====================================================
-- VISTA 8: FUNCIÓN DE VENTANA - ROW_NUMBER
-- =====================================================
-- Competencia: Funciones de ventana (ROW_NUMBER)
-- Descripción: Ranking de alquileres por turista

CREATE VIEW v_Ranking_Alquileres_Turista AS
SELECT 
    U.email,
    A.id_alquiler,
    A.fecha_inicio,
    B.Marca + ' ' + B.Modelo AS bicicleta,
    P.monto,
    ROW_NUMBER() OVER (PARTITION BY A.id_turista ORDER BY A.fecha_inicio DESC) AS numero_alquiler,
    COUNT(*) OVER (PARTITION BY A.id_turista) AS total_alquileres_turista
FROM Alquiler A
INNER JOIN Turista T ON A.id_turista = T.id_turista
INNER JOIN Usuario U ON T.id_turista = U.id_usuario
INNER JOIN Bicicleta B ON A.id_bicicleta = B.id_bicicleta
INNER JOIN Pago P ON A.id_alquiler = P.id_alquiler;
GO

PRINT 'Vista 8 creada: v_Ranking_Alquileres_Turista';
GO

-- =====================================================
-- VISTA 9: FUNCIÓN DE VENTANA - RANK
-- =====================================================
-- Competencia: Funciones de ventana (RANK)
-- Descripción: Ranking de bicicletas por calificación

CREATE VIEW v_Ranking_Bicicletas_Calificacion AS
SELECT 
    B.id_bicicleta,
    B.Marca,
    B.Modelo,
    P.Nombre AS punto_alquiler,
    COUNT(R.id_reseña) AS cantidad_reseñas,
    AVG(R.calificacion) AS calificacion_promedio,
    RANK() OVER (ORDER BY AVG(R.calificacion) DESC) AS ranking_calificacion,
    DENSE_RANK() OVER (PARTITION BY P.id_punto_de_alquiler ORDER BY AVG(R.calificacion) DESC) AS ranking_por_punto
FROM Bicicleta B
INNER JOIN Punto_de_Alquiler P ON B.id_punto_de_alquiler = P.id_punto_de_alquiler
LEFT JOIN Reseña R ON B.id_bicicleta = R.id_bicicleta
GROUP BY B.id_bicicleta, B.Marca, B.Modelo, P.id_punto_de_alquiler, P.Nombre
HAVING COUNT(R.id_reseña) > 0;
GO

PRINT 'Vista 9 creada: v_Ranking_Bicicletas_Calificacion';
GO

-- =====================================================
-- VISTA 10: FUNCIÓN DE VENTANA - ACUMULADOS
-- =====================================================
-- Competencia: Funciones de ventana con agregaciones
-- Descripción: Ingresos acumulados por fecha

CREATE VIEW v_Ingresos_Acumulados AS
SELECT 
    P.Fecha,
    P.id_alquiler,
    P.monto,
    SUM(P.monto) OVER (ORDER BY P.Fecha ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ingreso_acumulado,
    AVG(P.monto) OVER (ORDER BY P.Fecha ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS promedio_movil_3dias,
    COUNT(*) OVER (ORDER BY P.Fecha ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS pagos_acumulados
FROM Pago P;
GO

PRINT 'Vista 10 creada: v_Ingresos_Acumulados';
GO

-- =====================================================
-- VISTA 11: FILTRADO CONDICIONAL (CASE)
-- =====================================================
-- Competencia: Filtrado condicional con CASE
-- Descripción: Clasificación de bicicletas por estado

CREATE VIEW v_Bicicletas_Clasificadas AS
SELECT 
    B.id_bicicleta,
    B.Marca,
    B.Modelo,
    B.Kilometraje,
    B.Horas_Uso,
    EF.nombre AS estado_fisico,
    CASE 
        WHEN B.Kilometraje >= 300 THEN 'Requiere mantenimiento mayor'
        WHEN B.Kilometraje >= 200 THEN 'Requiere revisión'
        WHEN B.Kilometraje >= 100 THEN 'En buen estado'
        ELSE 'Como nueva'
    END AS estado_por_kilometraje,
    CASE 
        WHEN B.Horas_Uso >= 50 THEN 'Alto uso'
        WHEN B.Horas_Uso >= 30 THEN 'Uso moderado'
        WHEN B.Horas_Uso >= 10 THEN 'Poco uso'
        ELSE 'Casi sin uso'
    END AS estado_por_horas,
    CASE 
        WHEN B.Kilometraje >= 200 OR B.Horas_Uso >= 30 THEN 'MANTENIMIENTO PREVENTIVO'
        ELSE 'OK'
    END AS requiere_atencion
FROM Bicicleta B
INNER JOIN estado_Fisico_Bicicleta EF ON B.id_estado_fisico_bicicleta = EF.id_estado_fisico_bicicleta;
GO

PRINT 'Vista 11 creada: v_Bicicletas_Clasificadas';
GO

-- =====================================================
-- VISTA 12: FUNCIONES ESCALARES Y CONVERSIÓN
-- =====================================================
-- Competencia: Funciones escalares (fecha, texto, conversión)
-- Descripción: Análisis temporal de alquileres

CREATE VIEW v_Analisis_Temporal_Alquileres AS
SELECT 
    A.id_alquiler,
    U.email,
    A.fecha_inicio,
    A.fecha_Fin,
    DATENAME(WEEKDAY, A.fecha_inicio) AS dia_semana_inicio,
    DATENAME(MONTH, A.fecha_inicio) AS mes_inicio,
    DATEPART(HOUR, A.fecha_inicio) AS hora_inicio,
    DATEDIFF(HOUR, A.fecha_inicio, ISNULL(A.fecha_Fin, GETDATE())) AS horas_duracion,
    DATEDIFF(DAY, A.fecha_inicio, ISNULL(A.fecha_Fin, GETDATE())) AS dias_duracion,
    CASE 
        WHEN A.fecha_Fin IS NULL THEN 'ACTIVO'
        ELSE 'FINALIZADO'
    END AS estado,
    UPPER(B.Marca) AS marca_mayusculas,
    LOWER(P.Nombre) AS punto_minusculas,
    CONVERT(VARCHAR(10), A.fecha_inicio, 103) AS fecha_formato_dd_mm_yyyy
FROM Alquiler A
INNER JOIN Turista T ON A.id_turista = T.id_turista
INNER JOIN Usuario U ON T.id_turista = U.id_usuario
INNER JOIN Bicicleta B ON A.id_bicicleta = B.id_bicicleta
INNER JOIN Punto_de_Alquiler P ON A.id_punto_de_alquiler = P.id_punto_de_alquiler;
GO

PRINT 'Vista 12 creada: v_Analisis_Temporal_Alquileres';
GO

-- =====================================================
-- VISTA 13: AGRUPAMIENTO CON HAVING
-- =====================================================
-- Competencia: GROUP BY con HAVING
-- Descripción: Turistas con múltiples alquileres

CREATE VIEW v_Turistas_Frecuentes AS
SELECT 
    T.id_turista,
    U.email,
    T.pais_procedente,
    COUNT(A.id_alquiler) AS total_alquileres,
    SUM(P.monto) AS total_gastado,
    AVG(P.monto) AS gasto_promedio,
    MIN(A.fecha_inicio) AS primer_alquiler,
    MAX(A.fecha_inicio) AS ultimo_alquiler,
    DATEDIFF(DAY, MIN(A.fecha_inicio), MAX(A.fecha_inicio)) AS dias_cliente
FROM Turista T
INNER JOIN Usuario U ON T.id_turista = U.id_usuario
INNER JOIN Alquiler A ON T.id_turista = A.id_turista
INNER JOIN Pago P ON A.id_alquiler = P.id_alquiler
GROUP BY T.id_turista, U.email, T.pais_procedente
HAVING COUNT(A.id_alquiler) >= 2;
GO

PRINT 'Vista 13 creada: v_Turistas_Frecuentes';
GO

-- =====================================================
-- VISTA 14: MÚLTIPLES JOINS COMPLEJOS
-- =====================================================
-- Competencia: JOINs complejos (5+ tablas)
-- Descripción: Información completa de alquileres

CREATE VIEW v_Alquileres_Completo AS
SELECT 
    A.id_alquiler,
    U.email AS turista,
    U.documento_identidad AS documento_turista,
    T.pais_procedente,
    B.id_bicicleta,
    B.Marca AS bici_marca,
    B.Modelo AS bici_modelo,
    B.Tamaño_del_Marco AS bici_tamaño,
    TT.nombre AS tipo_terreno,
    TA.nombre AS tipo_asistencia,
    EF.nombre AS estado_bicicleta,
    P.id_punto_de_alquiler,
    P.Nombre AS punto_alquiler,
    C.Nombre AS ciudad,
    C.codigoDane AS codigo_dane_ciudad,
    D.Nombre AS departamento,
    PL.id_plan,
    PL.nombre AS plan_nombre,
    PG.id_pago,
    PG.monto AS monto_pagado,
    PG.Fecha AS fecha_pago,
    TP.nombre AS tipo_pago,
    A.fecha_inicio,
    A.fecha_Fin,
    DATEDIFF(HOUR, A.fecha_inicio, ISNULL(A.fecha_Fin, GETDATE())) AS horas_alquiler,
    CASE 
        WHEN A.fecha_Fin IS NULL THEN 'ACTIVO'
        ELSE 'FINALIZADO'
    END AS estado_alquiler
FROM Alquiler A
	INNER JOIN Turista T ON A.id_turista = T.id_turista
	INNER JOIN Usuario U ON T.id_turista = U.id_usuario
	INNER JOIN Bicicleta B ON A.id_bicicleta = B.id_bicicleta
	INNER JOIN tipo_terreno TT ON B.id_terreno = TT.id_terreno
	INNER JOIN Tipo_Asistencia TA ON B.id_tipo_asistencia = TA.id_tipo_asistencia
	INNER JOIN estado_Fisico_Bicicleta EF ON B.id_estado_fisico_bicicleta = EF.id_estado_fisico_bicicleta
	INNER JOIN Punto_de_Alquiler P ON A.id_punto_de_alquiler = P.id_punto_de_alquiler
	INNER JOIN Ciudad C ON P.id_ciudad = C.id_ciudad
	INNER JOIN Departamento D ON C.id_departamento = D.id_departamento
	INNER JOIN Plan_De_Alquiler PL ON A.id_plan = PL.id_plan
	INNER JOIN Pago PG ON A.id_alquiler = PG.id_alquiler
	INNER JOIN Tipo_de_Pago TP ON PG.id_tipo_pago = TP.id_tipo_de_pago;

-- =====================================================
-- VISTA 15: SUBCONSULTA EN SELECT
-- =====================================================
-- Competencia: Subconsultas en lista SELECT
-- Descripción: Puntos de alquiler con estadísticas

CREATE VIEW v_Puntos_Con_Estadisticas AS
SELECT 
    P.id_punto_de_alquiler,
    P.Nombre,
    C.Nombre AS ciudad,
    P.Capacidad_Bicicletas,
    (SELECT COUNT(*) 
     FROM Bicicleta B 
     WHERE B.id_punto_de_alquiler = P.id_punto_de_alquiler) AS bicicletas_totales,
    (SELECT COUNT(*) 
     FROM Bicicleta B 
     INNER JOIN Disponibilidad_bicicleta DB ON B.id_disponibilidad = DB.id_disponibilidad
     WHERE B.id_punto_de_alquiler = P.id_punto_de_alquiler 
     AND DB.nombre = 'Disponible') AS bicicletas_disponibles,
    (SELECT COUNT(*) 
     FROM Alquiler A 
     WHERE A.id_punto_de_alquiler = P.id_punto_de_alquiler) AS total_alquileres,
    (SELECT SUM(PG.monto) 
     FROM Alquiler A 
     INNER JOIN Pago PG ON A.id_alquiler = PG.id_alquiler
     WHERE A.id_punto_de_alquiler = P.id_punto_de_alquiler) AS ingresos_totales,
    (SELECT COUNT(*) 
     FROM empleado E 
     WHERE E.id_punto_de_alquiler = P.id_punto_de_alquiler) AS cantidad_empleados
FROM Punto_de_Alquiler P
INNER JOIN Ciudad C ON P.id_ciudad = C.id_ciudad;
GO

PRINT 'Vista 15 creada: v_Puntos_Con_Estadisticas';
GO

-- =====================================================
-- VISTA 16: COMBINACIÓN COMPLETA (FULL OUTER JOIN)
-- =====================================================
-- Competencia: FULL OUTER JOIN
-- Descripción: Todas las ciudades y puntos (con o sin relación)

CREATE VIEW v_Cobertura_Completa AS
SELECT 
    ISNULL(C.Nombre, 'Sin ciudad') AS ciudad,
    ISNULL(D.Nombre, 'Sin departamento') AS departamento,
    ISNULL(P.Nombre, 'Sin punto de alquiler') AS punto_alquiler,
    CASE 
        WHEN P.id_punto_de_alquiler IS NULL THEN 'Ciudad sin cobertura'
        WHEN C.id_ciudad IS NULL THEN 'Punto sin ciudad asignada'
        ELSE 'Cobertura activa'
    END AS estado_cobertura
FROM Ciudad C
INNER JOIN Departamento D ON C.id_departamento = D.id_departamento
FULL OUTER JOIN Punto_de_Alquiler P ON C.id_ciudad = P.id_ciudad;
GO

PRINT 'Vista 16 creada: v_Cobertura_Completa';
GO

-- =====================================================
-- VISTA 17: AGRUPAMIENTO MÚLTIPLE CON ROLLUP
-- =====================================================
-- Competencia: Agrupamiento con ROLLUP para subtotales
-- Descripción: Ingresos con subtotales por ciudad y punto

CREATE VIEW v_Ingresos_Con_Subtotales AS
SELECT 
    ISNULL(C.Nombre, 'TOTAL GENERAL') AS ciudad,
    ISNULL(P.Nombre, 'Subtotal Ciudad') AS punto_alquiler,
    COUNT(A.id_alquiler) AS cantidad_alquileres,
    SUM(PG.monto) AS ingresos_totales,
    AVG(PG.monto) AS ingreso_promedio
FROM Ciudad C
INNER JOIN Punto_de_Alquiler P ON C.id_ciudad = P.id_ciudad
INNER JOIN Alquiler A ON P.id_punto_de_alquiler = A.id_punto_de_alquiler
INNER JOIN Pago PG ON A.id_alquiler = PG.id_alquiler
GROUP BY ROLLUP(C.Nombre, P.Nombre);
GO

PRINT 'Vista 17 creada: v_Ingresos_Con_Subtotales';
GO

-- =====================================================
-- VISTA 18: SUBCONSULTA CON EXISTS
-- =====================================================
-- Competencia: Subconsultas con EXISTS
-- Descripción: Bicicletas que han sido alquiladas

CREATE VIEW v_Bicicletas_Alquiladas AS
SELECT 
    B.id_bicicleta,
    B.Marca,
    B.Modelo,
    P.Nombre AS punto_alquiler,
    B.Kilometraje,
    B.Horas_Uso,
    (SELECT COUNT(*) 
     FROM Alquiler A 
     WHERE A.id_bicicleta = B.id_bicicleta) AS veces_alquilada,
    (SELECT MAX(A.fecha_inicio) 
     FROM Alquiler A 
     WHERE A.id_bicicleta = B.id_bicicleta) AS ultimo_alquiler
FROM Bicicleta B
INNER JOIN Punto_de_Alquiler P ON B.id_punto_de_alquiler = P.id_punto_de_alquiler
WHERE EXISTS (
    SELECT 1 
    FROM Alquiler A 
    WHERE A.id_bicicleta = B.id_bicicleta
);
GO

PRINT 'Vista 18 creada: v_Bicicletas_Alquiladas';
GO

-- =====================================================
-- VISTA 19: ANÁLISIS DE RENDIMIENTO POR EMPLEADO
-- =====================================================
-- Competencia: JOINs + Agregaciones + Subconsultas
-- Descripción: Rendimiento de empleados en puntos

CREATE VIEW v_Rendimiento_Empleados AS
SELECT 
    E.id_empleado,
    E.nombre AS empleado,
    CG.nombre AS cargo,
    P.Nombre AS punto_alquiler,
    C.Nombre AS ciudad,
    (SELECT COUNT(*) 
     FROM Alquiler A 
     WHERE A.id_punto_de_alquiler = E.id_punto_de_alquiler) AS alquileres_punto,
    (SELECT SUM(PG.monto) 
     FROM Alquiler A 
     INNER JOIN Pago PG ON A.id_alquiler = PG.id_alquiler
     WHERE A.id_punto_de_alquiler = E.id_punto_de_alquiler) AS ingresos_punto,
    (SELECT COUNT(*) 
     FROM Bicicleta B 
     WHERE B.id_punto_de_alquiler = E.id_punto_de_alquiler) AS bicicletas_gestionadas,
    (SELECT AVG(R.calificacion) 
     FROM Alquiler A 
     INNER JOIN Reseña R ON R.id_turista = A.id_turista
     WHERE A.id_punto_de_alquiler = E.id_punto_de_alquiler) AS calificacion_promedio_punto
FROM empleado E
INNER JOIN Cargo CG ON E.id_cargo = CG.id_cargo
INNER JOIN Punto_de_Alquiler P ON E.id_punto_de_alquiler = P.id_punto_de_alquiler
INNER JOIN Ciudad C ON P.id_ciudad = C.id_ciudad;
GO

PRINT 'Vista 19 creada: v_Rendimiento_Empleados';
GO

-- =====================================================
-- VISTA 20: RESUMEN MENSUAL DE OPERACIONES
-- =====================================================
-- Competencia: Agrupamiento con funciones de fecha
-- Descripción: Resumen de actividad mensual
-- Propósito: Dashboard ejecutivo simple para análisis temporal

CREATE VIEW v_Dashboard_Ejecutivo1 AS
SELECT 
    -- Información temporal del período
    YEAR(A.fecha_inicio) AS año,                              
    MONTH(A.fecha_inicio) AS mes,                             
    DATENAME(MONTH, A.fecha_inicio) AS nombre_mes,            
    
    -- Métricas de volumen de operaciones
    COUNT(A.id_alquiler) AS total_alquileres,                 
    COUNT(DISTINCT A.id_turista) AS turistas_diferentes,      
    
    -- Métricas financieras
    SUM(P.monto) AS ingresos_totales,                         
    AVG(P.monto) AS ingreso_promedio,                         
    MAX(P.monto) AS ingreso_maximo,                           
    MIN(P.monto) AS ingreso_minimo                            
    
FROM Alquiler A
    INNER JOIN Pago P ON A.id_alquiler = P.id_alquiler        
WHERE A.fecha_inicio IS NOT NULL                             
GROUP BY 
    YEAR(A.fecha_inicio),                                     
    MONTH(A.fecha_inicio),                                    
    DATENAME(MONTH, A.fecha_inicio);                          
GO

PRINT 'Vista 20 creada: v_Dashboard_Ejecutivo';
GO

