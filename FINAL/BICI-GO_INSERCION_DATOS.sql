

-- Tabla: tipo_de_documento_identidad
INSERT INTO tipo_de_documento_identidad (nombre, descripcion) VALUES
('Cédula de Ciudadanía', 'Documento de identidad colombiano'),
('Pasaporte', 'Documento de identidad internacional'),
('Cédula de Extranjería', 'Documento para extranjeros residentes'),
('Tarjeta de Identidad', 'Documento para menores de edad');
GO

-- Tabla: estado_Fisico_Bicicleta
INSERT INTO estado_Fisico_Bicicleta (nombre, descripcion) VALUES
('Excelente', 'Bicicleta en perfecto estado'),
('Bueno', 'Bicicleta en buen estado de funcionamiento'),
('Regular', 'Requiere mantenimiento preventivo'),
('En Reparación', 'Bicicleta en taller');
GO

-- Tabla: Tipo_Asistencia
INSERT INTO Tipo_Asistencia (nombre, descripcion) VALUES
('Convencional', 'Bicicleta sin asistencia eléctrica'),
('Eléctrica', 'Bicicleta con motor eléctrico');
GO

-- Tabla: Disponibilidad_bicicleta
INSERT INTO Disponibilidad_bicicleta (nombre, descripcion) VALUES
('Disponible', 'Lista para alquilar'),
('En Alquiler', 'Actualmente alquilada'),
('En Mantenimiento', 'No disponible por mantenimiento'),
('Reservada', 'Reservada por un cliente');
GO

-- Tabla: tipo_terreno
INSERT INTO tipo_terreno (nombre, descripcion) VALUES
('Montaña', 'Para terrenos irregulares y senderos'),
('Urbana', 'Para ciudad y pavimento'),
('Ruta', 'Para carreteras y largas distancias');
GO

-- Tabla: tipo_de_multimedia
INSERT INTO tipo_de_multimedia (nombre, descripcion) VALUES
('JPEG', 'Imagen formato JPEG'),
('PNG', 'Imagen formato PNG'),
('MP4', 'Video formato MP4'),
('WEBP', 'Imagen formato WebP');
GO

-- Tabla: Metodo_Pago
INSERT INTO Metodo_Pago (nombre, descripcion) VALUES
('Tarjeta de Crédito', 'Visa, Mastercard, American Express'),
('Tarjeta de Débito', 'Débito bancario'),
('PayPal', 'Pago digital PayPal'),
('Efectivo', 'Pago en efectivo en punto de alquiler');
GO

-- Tabla: Tipo_de_Pago
INSERT INTO Tipo_de_Pago (nombre, descripcion) VALUES
('Pago Completo', 'Pago total del alquiler'),
('Anticipo', 'Pago parcial inicial'),
('Depósito', 'Garantía reembolsable');
GO

-- Tabla: Duracion
INSERT INTO Duracion (nombre, descripcion) VALUES
('Por Hora', 'Tarifa por hora'),
('Por Día', 'Tarifa por día completo'),
('Por 3 Días', 'Paquete de 3 días'),
('Por Semana', 'Tarifa semanal'),
('Mensual', 'Tarifa mensual');
GO

-- Tabla: Moneda
INSERT INTO Moneda (codigo, nombre, simbolo) VALUES
('COP', 'Peso Colombiano', '$'),
('USD', 'Dólar Estadounidense', '$'),
('EUR', 'Euro', '€');
GO

-- Tabla: Cargo
INSERT INTO Cargo (nombre, descripcion) VALUES
('Gerente', 'Gerente del punto de alquiler'),
('Técnico', 'Técnico de mantenimiento'),
('Atención al Cliente', 'Encargado de atención'),
('Supervisor', 'Supervisor de operaciones');
GO

-- Tabla: tipo_telefono
INSERT INTO tipo_telefono (nombre) VALUES
('Móvil'),
('Fijo'),
('WhatsApp');
GO

PRINT 'Catálogos insertados correctamente.';
GO

-- =====================================================
-- TABLAS DE UBICACIÓN GEOGRÁFICA
-- =====================================================

-- Tabla: Departamento (Códigos DANE reales de Colombia)
INSERT INTO Departamento (Nombre, codigoDane) VALUES
('Cundinamarca', 25),
('Antioquia', 5),
('Valle del Cauca', 76),
('Atlántico', 8),
('Bolívar', 13);
GO

-- Tabla: Ciudad (Códigos DANE reales)
INSERT INTO Ciudad (Nombre, codigoDane, id_departamento) VALUES
('Bogotá', 11001, 1),
('Zipaquirá', 25899, 1),
('Medellín', 5001, 2),
('Envigado', 5266, 2),
('Cali', 76001, 3),
('Barranquilla', 8001, 4),
('Cartagena', 13001, 5);
GO

PRINT 'Ubicaciones geográficas insertadas correctamente.';
GO

-- =====================================================
-- TABLAS DE USUARIOS
-- =====================================================

-- Tabla: Usuario
INSERT INTO Usuario (email, contraseña, documento_identidad, fecha_registro, fecha_nacimiento, telefono, id_tipo_documento_identidad) VALUES
('carlos.rodriguez@email.com', 'hash123', '1234567890', '2024-01-15', '1990-05-20', '3101234567', 1),
('maria.garcia@email.com', 'hash456', '9876543210', '2024-02-10', '1985-08-15', '3209876543', 1),
('john.smith@email.com', 'hash789', 'P12345678', '2024-03-05', '1992-11-30', '3157654321', 2),
('laura.martinez@email.com', 'hash321', '1122334455', '2024-01-20', '1988-03-12', '3186547890', 1),
('admin@bicigo.com', 'admin123', '9988776655', '2023-12-01', '1980-01-01', '3001112233', 1);
GO

-- Tabla: Turista
INSERT INTO Turista (id_turista, pais_procedente) VALUES
(1, 'Colombia'),
(2, 'Colombia'),
(3, 'Estados Unidos'),
(4, 'España');
GO

-- Tabla: Administrador
INSERT INTO Administrador (id_administrador, cargo) VALUES
(5, 'Administrador General');
GO

PRINT 'Usuarios insertados correctamente.';
GO

-- =====================================================
-- TABLAS DE INFRAESTRUCTURA
-- =====================================================

-- Tabla: Horario
INSERT INTO Horario (dias_operacion, horario_inicio, horario_Fin) VALUES
('Lunes a Viernes', '08:00:00', '18:00:00'),
('Lunes a Domingo', '07:00:00', '20:00:00'),
('Sábados y Domingos', '09:00:00', '17:00:00');
GO

-- Tabla: Punto_de_Alquiler
INSERT INTO Punto_de_Alquiler (Nombre, Latitud, Longitud, Capacidad_Bicicletas, id_ciudad, id_horario) VALUES
('BICI-GO Candelaria', 4.5981, -74.0758, 30, 1, 2),
('BICI-GO Zipaquirá Centro', 5.0258, -74.0039, 20, 2, 1),
('BICI-GO Medellín Parque Lleras', 6.2476, -75.5658, 25, 3, 2),
('BICI-GO Cali Centro', 3.4516, -76.5320, 20, 5, 1);
GO

-- Tabla: Cobertura
INSERT INTO Cobertura (id_punto_de_alquiler, id_ciudad) VALUES
(1, 1),
(2, 2),
(3, 3),
(3, 4),
(4, 5);
GO

-- Tabla: empleado
INSERT INTO empleado (nombre, telefono, id_cargo, id_tipo_telefono, id_punto_de_alquiler) VALUES
('Juan Pérez', '3001234567', 1, 1, 1),
('Ana López', '3109876543', 3, 1, 1),
('Pedro Ramírez', '3157654321', 2, 1, 2),
('Sofia Castro', '3186547890', 3, 1, 3);
GO

-- Tabla: servicio
INSERT INTO servicio (Nombre, Descripcion, Estado) VALUES
('Taller de Reparación', 'Servicio de reparación y mantenimiento', 'Activo'),
('Venta de Accesorios', 'Cascos, candados, luces', 'Activo'),
('Guías Turísticas', 'Guías locales para rutas', 'Activo'),
('Estacionamiento', 'Parqueadero seguro', 'Activo');
GO

-- Tabla: servicio_punto_de_alquiler
INSERT INTO servicio_punto_de_alquiler (id_punto, id_servicio) VALUES
(1, 1),
(1, 2),
(1, 4),
(2, 1),
(3, 1),
(3, 2),
(3, 3);
GO

PRINT 'Infraestructura insertada correctamente.';
GO

-- =====================================================
-- TABLAS DE BICICLETAS
-- =====================================================

-- Tabla: Bicicleta
INSERT INTO Bicicleta (Tamaño_del_Marco, Kilometraje, Marca, Modelo, Año_Fabricacion, Horas_Uso, 
    id_estado_fisico_bicicleta, id_tipo_asistencia, id_disponibilidad, id_terreno, id_punto_de_alquiler) VALUES
('M', 150, 'Trek', 'Marlin 5', 2023, 25.5, 1, 1, 1, 1, 1),
('L', 80, 'Specialized', 'Rockhopper', 2023, 15.0, 1, 1, 1, 1, 1),
('S', 200, 'Giant', 'Escape 3', 2022, 35.0, 2, 1, 1, 2, 1),
('M', 50, 'Cannondale', 'Quick 4', 2024, 8.0, 1, 2, 1, 2, 2),
('L', 120, 'Scott', 'Speedster', 2023, 20.0, 1, 1, 2, 3, 2),
('M', 0, 'Trek', 'FX 2', 2024, 0, 1, 1, 1, 2, 3),
('XL', 300, 'Giant', 'Talon 2', 2021, 50.0, 2, 1, 1, 1, 3),
('M', 90, 'Specialized', 'Turbo Vado', 2023, 18.0, 1, 2, 1, 2, 4);
GO

PRINT 'Bicicletas insertadas correctamente.';
GO

-- =====================================================
-- TABLAS DE PLANES Y TARIFAS
-- =====================================================

-- Tabla: Plan_De_Alquiler
INSERT INTO Plan_De_Alquiler (nombre, descripcion) VALUES
('Plan Básico', 'Plan de alquiler estándar'),
('Plan Turista', 'Incluye casco y mapa de rutas'),
('Plan Premium', 'Incluye seguro, casco y GPS'),
('Plan Estudiante', 'Descuento para estudiantes');
GO

-- Tabla: Beneficios_y_Condiciones
INSERT INTO Beneficios_y_Condiciones (descripcion, valor_duracion, id_plan) VALUES
('Incluye casco básico', NULL, 1),
('Incluye casco, mapa de rutas turísticas', NULL, 2),
('Incluye seguro contra daños, casco premium, GPS', NULL, 3),
('15% de descuento con carnet estudiantil', 0.15, 4);
GO

-- Tabla: Tarifa
INSERT INTO Tarifa (estado_Plan, fecha_Inicio, fecha_Fin, precio, id_plan, id_duracion, id_moneda) VALUES
(1, '2024-01-01', '2024-12-31', 8000.00, 1, 1, 1),
(1, '2024-01-01', '2024-12-31', 50000.00, 1, 2, 1),
(1, '2024-01-01', '2024-12-31', 12000.00, 2, 1, 1),
(1, '2024-01-01', '2024-12-31', 75000.00, 2, 2, 1),
(1, '2024-01-01', '2024-12-31', 200000.00, 2, 4, 1),
(1, '2024-01-01', '2024-12-31', 15000.00, 3, 1, 1),
(1, '2024-01-01', '2024-12-31', 90000.00, 3, 2, 1),
(1, '2024-01-01', '2024-12-31', 6000.00, 4, 1, 1);
GO

-- Tabla: punto_x_plan_de_alquiler
INSERT INTO punto_x_plan_de_alquiler (id_punto_de_alquiler, id_plan) VALUES
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 4),
(3, 1),
(3, 2),
(3, 3),
(4, 1),
(4, 2);
GO

PRINT 'Planes y tarifas insertados correctamente.';
GO

-- =====================================================
-- TABLAS DE ALQUILERES Y PAGOS
-- =====================================================

-- Tabla: Alquiler
INSERT INTO Alquiler (fecha_inicio, fecha_Fin, id_turista, id_bicicleta, id_punto_de_alquiler, id_plan) VALUES
('2024-11-01 09:00:00', '2024-11-01 17:00:00', 1, 1, 1, 1),
('2024-11-05 08:00:00', '2024-11-05 20:00:00', 2, 3, 1, 2),
('2024-11-10 10:00:00', '2024-11-12 18:00:00', 3, 4, 2, 2),
('2024-11-15 07:00:00', NULL, 4, 6, 3, 3),
('2024-11-08 11:00:00', '2024-11-08 15:00:00', 1, 2, 1, 1),
('2024-11-12 09:00:00', '2024-11-14 17:00:00', 3, 5, 2, 2);
GO

-- Tabla: Historial_de_alquiler
INSERT INTO Historial_de_alquiler (id_alquiler, fecha_cambio, estado_anterior, estado_nuevo, observaciones, id_administrador) VALUES
(1, '2024-11-01 09:00:00', NULL, 'Iniciado', 'Alquiler iniciado correctamente', 5),
(1, '2024-11-01 17:00:00', 'Iniciado', 'Finalizado', 'Bicicleta devuelta en buen estado', 5),
(2, '2024-11-05 08:00:00', NULL, 'Iniciado', 'Alquiler iniciado', 5),
(2, '2024-11-05 20:00:00', 'Iniciado', 'Finalizado', 'Devolución exitosa', 5),
(4, '2024-11-15 07:00:00', NULL, 'Iniciado', 'Alquiler activo', 5);
GO

-- Tabla: Pago
INSERT INTO Pago (Fecha, id_tipo_pago, id_alquiler, monto) VALUES
('2024-11-01', 1, 1, 50000.00),
('2024-11-05', 1, 2, 75000.00),
('2024-11-10', 1, 3, 200000.00),
('2024-11-15', 2, 4, 45000.00),
('2024-11-08', 1, 5, 50000.00),
('2024-11-12', 1, 6, 200000.00);
GO

PRINT 'Alquileres y pagos insertados correctamente.';
GO

-- =====================================================
-- TABLAS DE RESEÑAS Y MULTIMEDIA
-- =====================================================

-- Tabla: Multimedia
INSERT INTO Multimedia (tamaño, descripcion, fecha_subida, id_tipo_de_multimedia) VALUES
(2.5, 'Vista de Monserrate desde La Candelaria', '2024-11-01 18:00:00', 1),
(1.8, 'Catedral de Sal en Zipaquirá', '2024-11-12 19:00:00', 1),
(15.5, 'Recorrido por ciclovía de Medellín', '2024-11-05 21:00:00', 3),
(3.2, 'Bicicleta Trek Marlin 5', '2024-11-01 17:30:00', 2);
GO

-- Tabla: Reseña
INSERT INTO Reseña (calificacion, fecha, comentario, id_turista, id_bicicleta, id_multimedia) VALUES
(5.00, '2024-11-01', 'Excelente bicicleta, muy cómoda para recorrer el centro histórico', 1, 1, 1),
(4.50, '2024-11-05', 'Muy buena experiencia, la bici estaba en perfecto estado', 2, 3, NULL),
(5.00, '2024-11-12', 'Increíble recorrido, la bicicleta eléctrica facilitó mucho el viaje', 3, 4, 2),
(4.00, '2024-11-08', 'Buena bicicleta, aunque podría tener mejor suspensión', 1, 2, NULL);
GO

