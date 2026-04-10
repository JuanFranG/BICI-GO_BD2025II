CREATE DATABASE BICIGO
GO

-- Tabla: tipo_de_documento_identidad
-- Descripción: Tipos de documentos de identificación
CREATE TABLE tipo_de_documento_identidad (
    id_tipo_documento_identidad INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
GO

-- Tabla: estado_Fisico_Bicicleta
-- Descripción: Estados de mantenimiento de bicicletas
CREATE TABLE estado_Fisico_Bicicleta (
    id_estado_fisico_bicicleta INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
GO

-- Tabla: Tipo_Asistencia
-- Descripción: Tipos de asistencia de bicicletas (Convencional, Eléctrica)
CREATE TABLE Tipo_Asistencia (
    id_tipo_asistencia INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
GO

-- Tabla: Disponibilidad_bicicleta
-- Descripción: Estados de disponibilidad de bicicletas
CREATE TABLE Disponibilidad_bicicleta (
    id_disponibilidad INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
GO

-- Tabla: tipo_terreno
-- Descripción: Tipos de terreno para bicicletas (Montaña, Urbana, Ruta)
CREATE TABLE tipo_terreno (
    id_terreno INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
GO

-- Tabla: tipo_de_multimedia
-- Descripción: Tipos de archivos multimedia (JPEG, PNG, MP4, etc.)
CREATE TABLE tipo_de_multimedia (
    id_tipo_de_multimedia INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
GO

-- Tabla: Metodo_Pago
-- Descripción: Métodos de pago aceptados
CREATE TABLE Metodo_Pago (
    id_tipo_pago INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
GO

-- Tabla: Tipo_de_Pago
-- Descripción: Tipos de transacciones de pago
CREATE TABLE Tipo_de_Pago (
    id_tipo_de_pago INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
GO

-- Tabla: Duracion
-- Descripción: Duraciones de planes de alquiler (Por hora, Por día, etc.)
CREATE TABLE Duracion (
    id_duracion INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
GO

-- Tabla: Moneda
-- Descripción: Monedas para internacionalización de precios
-- NUEVA TABLA AGREGADA
CREATE TABLE Moneda (
    id_moneda INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    codigo VARCHAR(3) NOT NULL,        -- ISO 4217: COP, USD, EUR
    nombre VARCHAR(50) NOT NULL,
    simbolo VARCHAR(5),
    CONSTRAINT UQ_Moneda_codigo UNIQUE (codigo)
);
GO

-- Tabla: Cargo
-- Descripción: Cargos de empleados
-- NUEVA TABLA AGREGADA
CREATE TABLE Cargo (
    id_cargo INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200)
);
GO

-- Tabla: tipo_telefono
-- Descripción: Tipos de teléfono (Móvil, Fijo, WhatsApp)
-- NUEVA TABLA AGREGADA
CREATE TABLE tipo_telefono (
    id_tipo_telefono INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL
);
GO

-- =====================================================
-- TABLAS DE UBICACIÓN GEOGRÁFICA
-- =====================================================

-- Tabla: Departamento
-- Descripción: Departamentos de Colombia según códigos DANE
CREATE TABLE Departamento (
    id_departamento INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    codigoDane INTEGER NOT NULL,
    CONSTRAINT UQ_Departamento_codigoDane UNIQUE (codigoDane)
);
GO

-- Tabla: Ciudad
-- Descripción: Ciudades/Municipios de Colombia según códigos DANE
-- CORRECCIÓN: Agregado id_departamento como FK
CREATE TABLE Ciudad (
    id_ciudad INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    codigoDane INTEGER NOT NULL,
    id_departamento INTEGER NOT NULL,
    CONSTRAINT UQ_Ciudad_codigoDane UNIQUE (codigoDane),
    CONSTRAINT FK_Ciudad_Departamento FOREIGN KEY (id_departamento) 
        REFERENCES Departamento(id_departamento)
);
GO

-- =====================================================
-- TABLAS DE USUARIOS
-- =====================================================

-- Tabla: Usuario (Superclase)
-- Descripción: Usuarios base del sistema
CREATE TABLE Usuario (
    id_usuario INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    documento_identidad VARCHAR(50) NOT NULL,
    fecha_registro DATE NOT NULL,
    fecha_nacimiento DATE,
    telefono VARCHAR(20),
    id_tipo_documento_identidad INTEGER NOT NULL,
    CONSTRAINT UQ_Usuario_email UNIQUE (email),
    CONSTRAINT UQ_Usuario_documento UNIQUE (documento_identidad),
    CONSTRAINT FK_Usuario_TipoDocumento FOREIGN KEY (id_tipo_documento_identidad) 
        REFERENCES tipo_de_documento_identidad(id_tipo_documento_identidad)
);
GO

-- Tabla: Turista (Herencia de Usuario)
-- Descripción: Usuarios turistas que alquilan bicicletas
CREATE TABLE Turista (
    id_turista INTEGER NOT NULL PRIMARY KEY,
    pais_procedente VARCHAR(100),
    CONSTRAINT FK_Turista_Usuario FOREIGN KEY (id_turista) 
        REFERENCES Usuario(id_usuario)
);
GO

-- Tabla: Administrador (Herencia de Usuario)
-- Descripción: Usuarios administradores del sistema
CREATE TABLE Administrador (
    id_administrador INTEGER NOT NULL PRIMARY KEY,
    cargo VARCHAR(100),
    CONSTRAINT FK_Administrador_Usuario FOREIGN KEY (id_administrador) 
        REFERENCES Usuario(id_usuario)
);
GO

-- =====================================================
-- TABLAS DE INFRAESTRUCTURA
-- =====================================================

-- Tabla: Horario
-- Descripción: Horarios de operación de puntos de alquiler
-- CORRECCIÓN: Eliminado campo 'formato', agregado 'dias_operacion', agregado CHECK constraint
CREATE TABLE Horario (
    id_horario INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    dias_operacion VARCHAR(100),       -- "Lunes a Viernes", "Todos los días", etc.
    horario_inicio TIME NOT NULL,
    horario_Fin TIME NOT NULL,
    CONSTRAINT CHK_Horario_ValidTime CHECK (horario_Fin > horario_inicio)
);
GO

-- Tabla: Punto_de_Alquiler
-- Descripción: Puntos físicos de alquiler de bicicletas
CREATE TABLE Punto_de_Alquiler (
    id_punto_de_alquiler INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Latitud DECIMAL(10,8),
    Longitud DECIMAL(11,8),
    Capacidad_Bicicletas INTEGER,
    id_ciudad INTEGER NOT NULL,
    id_horario INTEGER NOT NULL,
    CONSTRAINT FK_PuntoAlquiler_Ciudad FOREIGN KEY (id_ciudad) 
        REFERENCES Ciudad(id_ciudad),
    CONSTRAINT FK_PuntoAlquiler_Horario FOREIGN KEY (id_horario) 
        REFERENCES Horario(id_horario)
);
GO

-- Tabla: Cobertura
-- Descripción: Relación N:M entre Punto_de_Alquiler y Ciudad
CREATE TABLE Cobertura (
    id_punto_de_alquiler INTEGER NOT NULL,
    id_ciudad INTEGER NOT NULL,
    PRIMARY KEY (id_punto_de_alquiler, id_ciudad),
    CONSTRAINT FK_Cobertura_PuntoAlquiler FOREIGN KEY (id_punto_de_alquiler) 
        REFERENCES Punto_de_Alquiler(id_punto_de_alquiler),
    CONSTRAINT FK_Cobertura_Ciudad FOREIGN KEY (id_ciudad) 
        REFERENCES Ciudad(id_ciudad)
);
GO

-- Tabla: empleado
-- Descripción: Empleados de puntos de alquiler
-- CORRECCIÓN: Agregado id_punto_de_alquiler como FK, cambiado 'cargo' a id_cargo, agregado id_tipo_telefono
CREATE TABLE empleado (
    id_empleado INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    id_cargo INTEGER NOT NULL,
    id_tipo_telefono INTEGER,
    id_punto_de_alquiler INTEGER NOT NULL,
    CONSTRAINT FK_Empleado_Cargo FOREIGN KEY (id_cargo) 
        REFERENCES Cargo(id_cargo),
    CONSTRAINT FK_Empleado_TipoTelefono FOREIGN KEY (id_tipo_telefono) 
        REFERENCES tipo_telefono(id_tipo_telefono),
    CONSTRAINT FK_Empleado_PuntoAlquiler FOREIGN KEY (id_punto_de_alquiler) 
        REFERENCES Punto_de_Alquiler(id_punto_de_alquiler)
);
GO

-- =====================================================
-- TABLAS DE SERVICIOS
-- =====================================================

-- Tabla: servicio
-- Descripción: Servicios ofrecidos (taller, venta accesorios, etc.)
CREATE TABLE servicio (
    id_servicio INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Estado VARCHAR(50)
);
GO

-- Tabla: servicio_punto_de_alquiler
-- Descripción: Relación N:M entre Servicio y Punto_de_Alquiler
CREATE TABLE servicio_punto_de_alquiler (
    id_punto INTEGER NOT NULL,
    id_servicio INTEGER NOT NULL,
    PRIMARY KEY (id_punto, id_servicio),
    CONSTRAINT FK_ServicioPunto_Punto FOREIGN KEY (id_punto) 
        REFERENCES Punto_de_Alquiler(id_punto_de_alquiler),
    CONSTRAINT FK_ServicioPunto_Servicio FOREIGN KEY (id_servicio) 
        REFERENCES servicio(id_servicio)
);
GO

-- =====================================================
-- TABLAS DE BICICLETAS
-- =====================================================

-- Tabla: Bicicleta
-- Descripción: Inventario de bicicletas
-- CORRECCIÓN: Cambiado id_asignados a id_punto_de_alquiler NOT NULL, eliminado tipo_tamaño_marco (ahora es atributo simple)
CREATE TABLE Bicicleta (
    id_bicicleta INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Tamaño_del_Marco VARCHAR(20),      -- Atributo simple: "S", "M", "L", "XL"
    Kilometraje INTEGER DEFAULT 0,
    Marca VARCHAR(50),
    Modelo VARCHAR(50),
    Año_Fabricacion INTEGER,
    Horas_Uso DECIMAL(10,2) DEFAULT 0,
    id_estado_fisico_bicicleta INTEGER NOT NULL,
    id_tipo_asistencia INTEGER NOT NULL,
    id_disponibilidad INTEGER NOT NULL,
    id_terreno INTEGER NOT NULL,
    id_punto_de_alquiler INTEGER NOT NULL,
    CONSTRAINT FK_Bicicleta_EstadoFisico FOREIGN KEY (id_estado_fisico_bicicleta) 
        REFERENCES estado_Fisico_Bicicleta(id_estado_fisico_bicicleta),
    CONSTRAINT FK_Bicicleta_TipoAsistencia FOREIGN KEY (id_tipo_asistencia) 
        REFERENCES Tipo_Asistencia(id_tipo_asistencia),
    CONSTRAINT FK_Bicicleta_Disponibilidad FOREIGN KEY (id_disponibilidad) 
        REFERENCES Disponibilidad_bicicleta(id_disponibilidad),
    CONSTRAINT FK_Bicicleta_Terreno FOREIGN KEY (id_terreno) 
        REFERENCES tipo_terreno(id_terreno),
    CONSTRAINT FK_Bicicleta_PuntoAlquiler FOREIGN KEY (id_punto_de_alquiler) 
        REFERENCES Punto_de_Alquiler(id_punto_de_alquiler)
);
GO

-- =====================================================
-- TABLAS DE PLANES Y TARIFAS
-- =====================================================

-- Tabla: Plan_De_Alquiler
-- Descripción: Planes de alquiler disponibles
CREATE TABLE Plan_De_Alquiler (
    id_plan INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);
GO

-- Tabla: Beneficios_y_Condiciones
-- Descripción: Beneficios y condiciones de los planes
CREATE TABLE Beneficios_y_Condiciones (
    id_beneficio INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion TEXT,
    valor_duracion DECIMAL(10,2),
    id_plan INTEGER NOT NULL,
    CONSTRAINT FK_Beneficios_Plan FOREIGN KEY (id_plan) 
        REFERENCES Plan_De_Alquiler(id_plan)
);
GO

-- Tabla: Tarifa
-- Descripción: Tarifas de planes según duración
-- CORRECCIÓN: Agregado CHECK constraint para fechas, agregado id_moneda
CREATE TABLE Tarifa (
    id_tarifa INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    estado_Plan BIT NOT NULL DEFAULT 1,  -- 1=Activo, 0=Inactivo
    fecha_Inicio DATE,
    fecha_Fin DATE,
    precio DECIMAL(10,2) NOT NULL,
    id_plan INTEGER NOT NULL,
    id_duracion INTEGER NOT NULL,
    id_moneda INTEGER NOT NULL,
    CONSTRAINT CHK_Tarifa_Fechas CHECK (fecha_Fin >= fecha_Inicio OR fecha_Fin IS NULL),
    CONSTRAINT CHK_Tarifa_Precio CHECK (precio >= 0),
    CONSTRAINT FK_Tarifa_Plan FOREIGN KEY (id_plan) 
        REFERENCES Plan_De_Alquiler(id_plan),
    CONSTRAINT FK_Tarifa_Duracion FOREIGN KEY (id_duracion) 
        REFERENCES Duracion(id_duracion),
    CONSTRAINT FK_Tarifa_Moneda FOREIGN KEY (id_moneda) 
        REFERENCES Moneda(id_moneda)
);
GO

-- Tabla: punto_x_plan_de_alquiler
-- Descripción: Relación N:M entre Punto_de_Alquiler y Plan_De_Alquiler
-- NUEVA TABLA AGREGADA
CREATE TABLE punto_x_plan_de_alquiler (
    id_punto_de_alquiler INTEGER NOT NULL,
    id_plan INTEGER NOT NULL,
    PRIMARY KEY (id_punto_de_alquiler, id_plan),
    CONSTRAINT FK_PuntoPlan_Punto FOREIGN KEY (id_punto_de_alquiler) 
        REFERENCES Punto_de_Alquiler(id_punto_de_alquiler),
    CONSTRAINT FK_PuntoPlan_Plan FOREIGN KEY (id_plan) 
        REFERENCES Plan_De_Alquiler(id_plan)
);
GO

-- =====================================================
-- TABLAS DE ALQUILERES Y PAGOS
-- =====================================================

-- Tabla: Alquiler
-- Descripción: Registro de alquileres individuales
CREATE TABLE Alquiler (
    id_alquiler INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    fecha_inicio DATETIME NOT NULL,
    fecha_Fin DATETIME,
    id_turista INTEGER NOT NULL,
    id_bicicleta INTEGER NOT NULL,
    id_punto_de_alquiler INTEGER NOT NULL,
    id_plan INTEGER NOT NULL,
    CONSTRAINT CHK_Alquiler_Fechas CHECK (fecha_Fin >= fecha_inicio OR fecha_Fin IS NULL),
    CONSTRAINT FK_Alquiler_Turista FOREIGN KEY (id_turista) 
        REFERENCES Turista(id_turista),
    CONSTRAINT FK_Alquiler_Bicicleta FOREIGN KEY (id_bicicleta) 
        REFERENCES Bicicleta(id_bicicleta),
    CONSTRAINT FK_Alquiler_PuntoAlquiler FOREIGN KEY (id_punto_de_alquiler) 
        REFERENCES Punto_de_Alquiler(id_punto_de_alquiler),
    CONSTRAINT FK_Alquiler_Plan FOREIGN KEY (id_plan) 
        REFERENCES Plan_De_Alquiler(id_plan)
);
GO

-- Tabla: Historial_de_alquiler
-- Descripción: Auditoría de cambios en alquileres
-- NUEVA TABLA AGREGADA
CREATE TABLE Historial_de_alquiler (
    id_historial INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_alquiler INTEGER NOT NULL,
    fecha_cambio DATETIME NOT NULL DEFAULT GETDATE(),
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50) NOT NULL,
    observaciones TEXT,
    id_administrador INTEGER,
    CONSTRAINT FK_Historial_Alquiler FOREIGN KEY (id_alquiler) 
        REFERENCES Alquiler(id_alquiler),
    CONSTRAINT FK_Historial_Administrador FOREIGN KEY (id_administrador) 
        REFERENCES Administrador(id_administrador)
);
GO

-- Tabla: Pago
-- Descripción: Pagos/Facturas de alquileres
CREATE TABLE Pago (
    id_pago INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Fecha DATE NOT NULL,
    id_tipo_pago INTEGER NOT NULL,
    id_alquiler INTEGER NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    CONSTRAINT CHK_Pago_Monto CHECK (monto >= 0),
    CONSTRAINT FK_Pago_TipoPago FOREIGN KEY (id_tipo_pago) 
        REFERENCES Tipo_de_Pago(id_tipo_de_pago),
    CONSTRAINT FK_Pago_Alquiler FOREIGN KEY (id_alquiler) 
        REFERENCES Alquiler(id_alquiler)
);
GO

-- =====================================================
-- TABLAS DE RESEÑAS Y MULTIMEDIA
-- =====================================================

-- Tabla: Multimedia
-- Descripción: Archivos multimedia (fotos, videos)
-- CORRECCIÓN: Cambiado id_tipo a id_tipo_de_multimedia INTEGER con FK
CREATE TABLE Multimedia (
    id_multimedia INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    tamaño DECIMAL(10,2),
    descripcion TEXT,
    fecha_subida DATETIME NOT NULL DEFAULT GETDATE(),
    id_tipo_de_multimedia INTEGER NOT NULL,
    CONSTRAINT FK_Multimedia_Tipo FOREIGN KEY (id_tipo_de_multimedia) 
        REFERENCES tipo_de_multimedia(id_tipo_de_multimedia)
);
GO

-- Tabla: Reseña
-- Descripción: Reseñas y calificaciones de usuarios
-- CORRECCIÓN: Agregado CHECK constraint para calificación 1-5
CREATE TABLE Reseña (
    id_reseña INTEGER IDENTITY(1,1) NOT NULL PRIMARY KEY,
    calificacion DECIMAL(3,2),
    fecha DATE NOT NULL,
    comentario TEXT,
    id_turista INTEGER NOT NULL,
    id_bicicleta INTEGER,
    id_multimedia INTEGER,
    CONSTRAINT CHK_Reseña_Calificacion CHECK (calificacion >= 1.00 AND calificacion <= 5.00),
    CONSTRAINT FK_Reseña_Turista FOREIGN KEY (id_turista) 
        REFERENCES Turista(id_turista),
    CONSTRAINT FK_Reseña_Bicicleta FOREIGN KEY (id_bicicleta) 
        REFERENCES Bicicleta(id_bicicleta),
    CONSTRAINT FK_Reseña_Multimedia FOREIGN KEY (id_multimedia) 
        REFERENCES Multimedia(id_multimedia)
);
GO
