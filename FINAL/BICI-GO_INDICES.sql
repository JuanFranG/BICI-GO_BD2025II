

-- Índices en tabla Bicicleta
CREATE INDEX IX_Bicicleta_Disponibilidad ON Bicicleta(id_disponibilidad);
CREATE INDEX IX_Bicicleta_PuntoAlquiler ON Bicicleta(id_punto_de_alquiler);
CREATE INDEX IX_Bicicleta_Terreno ON Bicicleta(id_terreno);
GO

-- Índices en tabla Alquiler
CREATE INDEX IX_Alquiler_Turista ON Alquiler(id_turista);
CREATE INDEX IX_Alquiler_FechaInicio ON Alquiler(fecha_inicio);
CREATE INDEX IX_Alquiler_Bicicleta ON Alquiler(id_bicicleta);
GO

-- Índices en tabla Pago
CREATE INDEX IX_Pago_Alquiler ON Pago(id_alquiler);
CREATE INDEX IX_Pago_Fecha ON Pago(Fecha);
GO

-- Índices en tabla Reseña
CREATE INDEX IX_Reseña_Bicicleta ON Reseña(id_bicicleta);
CREATE INDEX IX_Reseña_Turista ON Reseña(id_turista);
GO

-- Índices en tabla Usuario
CREATE INDEX IX_Usuario_Email ON Usuario(email);
GO

-- Índices en tabla Ciudad
CREATE INDEX IX_Ciudad_Departamento ON Ciudad(id_departamento);
GO

-- Índices en tabla Punto_de_Alquiler
CREATE INDEX IX_PuntoAlquiler_Ciudad ON Punto_de_Alquiler(id_ciudad);
GO

-- Índices en tabla empleado
CREATE INDEX IX_Empleado_PuntoAlquiler ON empleado(id_punto_de_alquiler);
GO

-- Índices en tabla Tarifa
CREATE INDEX IX_Tarifa_Plan ON Tarifa(id_plan);
GO

PRINT 'Índices creados exitosamente';
GO
