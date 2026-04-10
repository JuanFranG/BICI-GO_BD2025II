# BICI-GO — Proyecto de Base de Datos (BD2025II)

## DATOS
**Programa:** Ingeniería de Sistemas, 2026-1
**Universidad:** Universidad del Magdalena

Hecho por:
 # Juan Gonzalez
 # David Brunal
 # Luis Muñoz
 # Jaime Rincón
 # Camilo Mancilla

## Descripción General

**BICI-GO** es un sistema de gestión de bases de datos relacional diseñado para la administración integral de una empresa de alquiler de bicicletas. El modelo soporta múltiples roles de usuario (Administrador, Empleado, Turista), control de inventario de flota con especificaciones técnicas (tipo de terreno, asistencia, estado físico), gestión de puntos de alquiler, procesamiento transaccional de alquileres/pagos, y un módulo de reseñas con soporte para metadatos multimedia.

Toda la lógica de negocio, reglas de cálculo y reportes gerenciales están centralizados y optimizados directamente en el motor de base de datos mediante T-SQL.

---

## Estructura del Repositorio

La organización de los archivos refleja el proceso de diseño y la implementación de la base de datos:

```
BICI-GO_BD2025II/
├── Modelos/
│   ├── conceptualv4_1.jpg           # Modelo conceptual (parte 1)
│   ├── conceptualv4_2.jpg           # Modelo conceptual (parte 2)
│   ├── conceptualv4_3.jpg           # Modelo conceptual (parte 3)
│   └── logico_v3.jpg                # Modelo lógico relacional final
│
├── Documentacion/
│   └── HU_-_FINAL.pdf               # Historias de usuario y criterios de aceptación
│
├── Scripts_SQL/
│   ├── BICI-GO_INSERCION_DATOS.sql  # Poblado de tablas maestras y datos de prueba
│   ├── BICI-GO_FUNCIONES.sql        # Funciones escalares y de tabla
│   ├── BICI-GO_PROCEDIMIENTOS.sql   # Procedimientos almacenados transaccionales
│   ├── BICI-GO_VISTAS.sql           # Vistas para reportes y dashboards
│   └── BICI-GO_INDICES.sql          # Optimización de consultas
│
└── README.md                        # Este archivo
```

Motor y Tecnologías
Motor de Base de Datos: SQL Server (Transact-SQL)

Diseño: Modelado Entidad-Relación (MER) y normalización

Enfoque: Lógica centralizada en la base de datos (Programmability)

Módulo de Reseñas y Multimedia
Basado en las Historias de Usuario, el sistema permite a los turistas documentar sus recorridos. La base de datos soporta:

Tipado de Archivos: Control estricto de los formatos permitidos asociados a las reseñas.

Metadatos: Registro de fecha de subida, tamaño del archivo (con validación de límites) y descripciones.

Relación: Vinculación directa entre el turista, la bicicleta utilizada y el contenido multimedia generado.

Programmability y Lógica de Negocio
El sistema incluye objetos programables para garantizar la integridad de los datos y facilitar la interacción con futuras aplicaciones frontend/backend:

```
Procedimientos Almacenados (Transacciones)

Gestionan las operaciones de escritura y procesos complejos del negocio:

sp_RegistrarTurista: Inserta usuarios manejando la herencia entre la tabla Usuario y Turista, recuperando el ID generado de forma segura.
sp_IniciarAlquiler: Registra un nuevo servicio asignando una bicicleta específica a un turista.
sp_ListarPuntosAlquiler: Retorna la ubicación detallada y el conteo de bicicletas por punto de atención.
sp_BuscarBicicletasDisponibles: Filtra inventario en tiempo real por punto de alquiler.
```

```
Funciones (Cálculos de Negocio)

Encapsulan fórmulas y reglas de negocio para ser reutilizadas en consultas:

fn_CalcularHorasAlquiler: Determina la duración exacta de un servicio.
fn_CalcularCostoPorHoras: Aplica la tarifa base y calcula descuentos automáticos (ej. 15% de descuento en alquileres mayores a 24 horas).
fn_EstadoBicicletaPorUso: Analiza el kilometraje y horas de uso para determinar recomendaciones de mantenimiento preventivo.
fn_CalcularDescuentoFrecuente: Retorna porcentajes de descuento basados en el historial del turista.
```

```
Vistas (Reporting & Dashboards)

Consultas precompiladas para agilizar la lectura de datos comunes:
v_Alquileres_Basico: Desnormaliza la información cruzando alquileres, usuarios, bicicletas y puntos de atención.
v_Ingresos_Por_Punto: Totaliza métricas financieras (SUM, AVG) y volumen de operaciones agrupadas por sede.
v_Dashboard_Ejecutivo1: Extrae métricas mensuales (ingresos totales, promedio, turistas únicos) utilizando funciones de fecha avanzadas.
```
Optimización de Rendimiento
Se implementaron índices no agrupados (NONCLUSTERED INDEX) para acelerar las búsquedas en campos de alta concurrencia y llaves foráneas frecuentes, tales como:

Filtros de inventario: Disponibilidad, terreno y puntos de alquiler en la tabla Bicicleta.

Búsquedas transaccionales: Fechas de inicio, turistas y bicicletas en la tabla Alquiler.

Autenticación: Búsquedas por email en la tabla Usuario.

Instrucciones de Despliegue
Para levantar este proyecto en un entorno local (SQL Server Management Studio o Azure Data Studio), ejecuta los scripts estrictamente en el siguiente orden para respetar la integridad referencial:

Creación del Esquema (DDL): Ejecuta el script de creación de tablas principales (asegúrate de correr el script con los CREATE TABLE antes de insertar datos).

Inserción de Datos: Ejecuta BICI-GO_INSERCION_DATOS.sql para poblar los catálogos (Tipos de documento, Terrenos, Disponibilidad) y cargar la data transaccional de prueba.

Lógica Reutilizable: Ejecuta BICI-GO_FUNCIONES.sql.

Vistas: Ejecuta BICI-GO_VISTAS.sql.

Transacciones: Ejecuta BICI-GO_PROCEDIMIENTOS.sql.

Optimización: Ejecuta BICI-GO_INDICES.sql al final para indexar los datos ya insertados y mejorar el rendimiento.
