-- ============================================================
--  BASE DE DATOS: Reloj Pastillero
--  Descripción : Sistema de gestión para dispositivo
--                inteligente de administración de medicamentos
--  Motor        : MySQL 8.0+ / MariaDB 10.6+
--  Autor        : Administrador de Base de Datos
--  Fecha        : 2026-05-11
--  Versión      : 1.0
-- ============================================================

-- ------------------------------------------------------------
-- 0. CREACIÓN Y SELECCIÓN DE LA BASE DE DATOS
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS BD_reloj_pastillero
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE BD_reloj_pastillero;

-- ------------------------------------------------------------
-- Desactivar revisión de claves foráneas durante la carga
-- ------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;


-- ============================================================
-- 1. USUARIO
--    Núcleo del sistema. Persona que usa el reloj pastillero.
-- ============================================================
CREATE TABLE IF NOT EXISTS USUARIO (
    id_usuario        INT             NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(100)    NOT NULL,
    apellido          VARCHAR(100)    NOT NULL,
    fecha_nacimiento  DATE            NOT NULL,
    email             VARCHAR(150)    NOT NULL,
    telefono          VARCHAR(20)         NULL,
    contrasena_hash   VARCHAR(255)    NOT NULL,
    activo            BOOLEAN         NOT NULL DEFAULT TRUE,
    fecha_registro    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                      ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT PK_usuario         PRIMARY KEY (id_usuario),
    CONSTRAINT UQ_usuario_email   UNIQUE      (email)
) ENGINE=InnoDB COMMENT='Usuarios del sistema de reloj pastillero';


-- ============================================================
-- 2. PERFIL_MEDICO
--    Datos clínicos asociados a un usuario.
-- ============================================================
CREATE TABLE IF NOT EXISTS PERFIL_MEDICO (
    id_perfil            INT             NOT NULL AUTO_INCREMENT,
    id_usuario           INT             NOT NULL,
    peso                 DECIMAL(5,2)        NULL COMMENT 'Kilogramos',
    altura               DECIMAL(4,2)        NULL COMMENT 'Metros',
    alergias             TEXT                NULL,
    condiciones_cronicas TEXT                NULL,
    grupo_sanguineo      VARCHAR(5)          NULL COMMENT 'Ej: A+, O-',
    updated_at           TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
                                          ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT PK_perfil_medico   PRIMARY KEY (id_perfil),
    CONSTRAINT FK_perfil_usuario  FOREIGN KEY (id_usuario)
        REFERENCES USUARIO (id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Historial clínico del usuario';


-- ============================================================
-- 3. MEDICO
--    Profesional de salud que emite prescripciones.
-- ============================================================
CREATE TABLE IF NOT EXISTS MEDICO (
    id_medico         INT             NOT NULL AUTO_INCREMENT,
    nombre            VARCHAR(100)    NOT NULL,
    apellido          VARCHAR(100)    NOT NULL,
    especialidad      VARCHAR(100)        NULL,
    cedula_profesional VARCHAR(30)    NOT NULL,
    email             VARCHAR(150)        NULL,
    telefono          VARCHAR(20)         NULL,
    CONSTRAINT PK_medico              PRIMARY KEY (id_medico),
    CONSTRAINT UQ_medico_cedula       UNIQUE      (cedula_profesional)
) ENGINE=InnoDB COMMENT='Médicos prescriptores';


-- ============================================================
-- 4. MEDICAMENTO
--    Catálogo general de medicamentos disponibles.
-- ============================================================
CREATE TABLE IF NOT EXISTS MEDICAMENTO (
    id_medicamento  INT             NOT NULL AUTO_INCREMENT,
    nombre_comercial VARCHAR(150)   NOT NULL,
    nombre_generico  VARCHAR(150)   NOT NULL,
    descripcion      TEXT               NULL,
    presentacion     ENUM(
                         'pastilla',
                         'capsula',
                         'liquido',
                         'inyectable',
                         'parche',
                         'otro'
                     )              NOT NULL,
    concentracion    VARCHAR(50)        NULL COMMENT 'Ej: 500mg, 10mg/ml',
    unidad_medida    VARCHAR(30)    NOT NULL COMMENT 'mg, ml, UI',
    CONSTRAINT PK_medicamento PRIMARY KEY (id_medicamento)
) ENGINE=InnoDB COMMENT='Catálogo de medicamentos';


-- ============================================================
-- 5. PRESCRIPCION
--    Receta médica que vincula usuario, medicamento y médico.
-- ============================================================
CREATE TABLE IF NOT EXISTS PRESCRIPCION (
    id_prescripcion  INT             NOT NULL AUTO_INCREMENT,
    id_usuario       INT             NOT NULL,
    id_medicamento   INT             NOT NULL,
    id_medico        INT                 NULL,
    dosis            DECIMAL(6,2)    NOT NULL,
    unidad_dosis     VARCHAR(20)     NOT NULL COMMENT 'mg, ml, pastillas',
    fecha_inicio     DATE            NOT NULL,
    fecha_fin        DATE                NULL COMMENT 'NULL = tratamiento indefinido',
    indicaciones     TEXT                NULL,
    activa           BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_prescripcion          PRIMARY KEY (id_prescripcion),
    CONSTRAINT FK_presc_usuario         FOREIGN KEY (id_usuario)
        REFERENCES USUARIO (id_usuario)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_presc_medicamento     FOREIGN KEY (id_medicamento)
        REFERENCES MEDICAMENTO (id_medicamento)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_presc_medico          FOREIGN KEY (id_medico)
        REFERENCES MEDICO (id_medico)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Prescripciones médicas activas e históricas';


-- ============================================================
-- 6. HORARIO_TOMA
--    Define cuándo debe tomarse cada medicamento prescrito.
-- ============================================================
CREATE TABLE IF NOT EXISTS HORARIO_TOMA (
    id_horario        INT             NOT NULL AUTO_INCREMENT,
    id_prescripcion   INT             NOT NULL,
    hora              TIME            NOT NULL,
    dias_semana       VARCHAR(13)     NOT NULL COMMENT 'CSV: L,M,X,J,V,S,D',
    frecuencia_horas  INT                 NULL COMMENT 'Alternativo: cada N horas',
    con_alimentos     BOOLEAN         NOT NULL DEFAULT FALSE,
    activo            BOOLEAN         NOT NULL DEFAULT TRUE,
    CONSTRAINT PK_horario_toma        PRIMARY KEY (id_horario),
    CONSTRAINT FK_horario_prescripcion FOREIGN KEY (id_prescripcion)
        REFERENCES PRESCRIPCION (id_prescripcion)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Programación horaria de cada dosis';


-- ============================================================
-- 7. DISPOSITIVO
--    Reloj pastillero físico registrado en el sistema.
-- ============================================================
CREATE TABLE IF NOT EXISTS DISPOSITIVO (
    id_dispositivo   INT             NOT NULL AUTO_INCREMENT,
    id_usuario       INT             NOT NULL,
    numero_serie     VARCHAR(50)     NOT NULL,
    modelo           VARCHAR(80)     NOT NULL,
    firmware_version VARCHAR(20)         NULL,
    fecha_activacion DATE                NULL,
    estado           ENUM(
                         'activo',
                         'inactivo',
                         'mantenimiento'
                     )              NOT NULL DEFAULT 'activo',
    bateria_pct      TINYINT UNSIGNED    NULL COMMENT '0-100%',
    CONSTRAINT PK_dispositivo        PRIMARY KEY (id_dispositivo),
    CONSTRAINT UQ_dispositivo_serie  UNIQUE      (numero_serie),
    CONSTRAINT FK_disp_usuario       FOREIGN KEY (id_usuario)
        REFERENCES USUARIO (id_usuario)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Dispositivos reloj pastillero registrados';


-- ============================================================
-- 8. COMPARTIMENTO
--    Slot físico dentro del reloj pastillero.
-- ============================================================
CREATE TABLE IF NOT EXISTS COMPARTIMENTO (
    id_compartimento  INT             NOT NULL AUTO_INCREMENT,
    id_dispositivo    INT             NOT NULL,
    id_medicamento    INT                 NULL,
    numero_slot       TINYINT         NOT NULL COMMENT 'Posición 1-N',
    etiqueta          VARCHAR(50)         NULL,
    capacidad_unidades INT            NOT NULL COMMENT 'Máx pastillas que caben',
    CONSTRAINT PK_compartimento       PRIMARY KEY (id_compartimento),
    CONSTRAINT UQ_comp_slot           UNIQUE      (id_dispositivo, numero_slot),
    CONSTRAINT FK_comp_dispositivo    FOREIGN KEY (id_dispositivo)
        REFERENCES DISPOSITIVO (id_dispositivo)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_comp_medicamento    FOREIGN KEY (id_medicamento)
        REFERENCES MEDICAMENTO (id_medicamento)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Compartimentos físicos del pastillero';


-- ============================================================
-- 9. INVENTARIO
--    Stock actual de pastillas en cada compartimento.
-- ============================================================
CREATE TABLE IF NOT EXISTS INVENTARIO (
    id_inventario         INT             NOT NULL AUTO_INCREMENT,
    id_compartimento      INT             NOT NULL,
    cantidad_actual       INT             NOT NULL DEFAULT 0,
    fecha_ultima_recarga  TIMESTAMP           NULL,
    fecha_caducidad_lote  DATE                NULL,
    alerta_stock_minimo   INT             NOT NULL DEFAULT 5
                                          COMMENT 'Avisar cuando baje de este valor',
    CONSTRAINT PK_inventario             PRIMARY KEY (id_inventario),
    CONSTRAINT UQ_inv_compartimento      UNIQUE      (id_compartimento),
    CONSTRAINT FK_inv_compartimento      FOREIGN KEY (id_compartimento)
        REFERENCES COMPARTIMENTO (id_compartimento)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Control de stock por compartimento';


-- ============================================================
-- 10. ALARMA
--     Configuración de la alerta para cada horario de toma.
-- ============================================================
CREATE TABLE IF NOT EXISTS ALARMA (
    id_alarma         INT             NOT NULL AUTO_INCREMENT,
    id_horario        INT             NOT NULL,
    id_dispositivo    INT             NOT NULL,
    tipo_alerta       ENUM(
                          'vibracion',
                          'sonido',
                          'luz',
                          'app',
                          'todos'
                      )              NOT NULL DEFAULT 'sonido',
    anticipacion_min  TINYINT         NOT NULL DEFAULT 0
                                      COMMENT 'Minutos antes de la hora programada',
    repetir_cada_min  TINYINT             NULL COMMENT 'Reintentos si no responde',
    activo            BOOLEAN         NOT NULL DEFAULT TRUE,
    CONSTRAINT PK_alarma              PRIMARY KEY (id_alarma),
    CONSTRAINT FK_alarma_horario      FOREIGN KEY (id_horario)
        REFERENCES HORARIO_TOMA (id_horario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_alarma_dispositivo  FOREIGN KEY (id_dispositivo)
        REFERENCES DISPOSITIVO (id_dispositivo)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Configuración de alarmas del dispositivo';


-- ============================================================
-- 11. REGISTRO_TOMA
--     Trazabilidad de cumplimiento: tomas realizadas/omitidas.
-- ============================================================
CREATE TABLE IF NOT EXISTS REGISTRO_TOMA (
    id_registro           INT             NOT NULL AUTO_INCREMENT,
    id_horario            INT             NOT NULL,
    id_usuario            INT             NOT NULL,
    fecha_hora_programada TIMESTAMP       NOT NULL,
    fecha_hora_real       TIMESTAMP           NULL COMMENT 'NULL si fue omitida',
    estado                ENUM(
                              'tomada',
                              'omitida',
                              'retrasada'
                          )              NOT NULL,
    metodo_confirmacion   ENUM(
                              'sensor',
                              'manual',
                              'app'
                          )                  NULL,
    observacion           TEXT                NULL,
    CONSTRAINT PK_registro_toma       PRIMARY KEY (id_registro),
    CONSTRAINT FK_reg_horario         FOREIGN KEY (id_horario)
        REFERENCES HORARIO_TOMA (id_horario)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_reg_usuario         FOREIGN KEY (id_usuario)
        REFERENCES USUARIO (id_usuario)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Historial de tomas realizadas y omitidas';


-- ============================================================
-- 12. CUIDADOR
--     Familiar o responsable que monitorea al usuario.
-- ============================================================
CREATE TABLE IF NOT EXISTS CUIDADOR (
    id_cuidador        INT             NOT NULL AUTO_INCREMENT,
    id_usuario         INT             NOT NULL COMMENT 'Usuario que es cuidado',
    nombre             VARCHAR(100)    NOT NULL,
    relacion           VARCHAR(50)     NOT NULL COMMENT 'hijo, esposo, enfermero...',
    email              VARCHAR(150)        NULL,
    telefono           VARCHAR(20)         NULL,
    puede_ver_historial BOOLEAN        NOT NULL DEFAULT FALSE,
    CONSTRAINT PK_cuidador            PRIMARY KEY (id_cuidador),
    CONSTRAINT FK_cuid_usuario        FOREIGN KEY (id_usuario)
        REFERENCES USUARIO (id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Cuidadores o responsables del usuario';


-- ============================================================
-- 13. NOTIFICACION
--     Alertas enviadas a cuidadores ante eventos del sistema.
-- ============================================================
CREATE TABLE IF NOT EXISTS NOTIFICACION (
    id_notificacion  INT             NOT NULL AUTO_INCREMENT,
    id_usuario       INT             NOT NULL,
    id_cuidador      INT             NOT NULL,
    tipo_evento      ENUM(
                         'toma_omitida',
                         'stock_bajo',
                         'caducidad_proxima',
                         'bateria_baja',
                         'dispositivo_inactivo'
                     )              NOT NULL,
    mensaje          TEXT            NOT NULL,
    canal            ENUM(
                         'email',
                         'sms',
                         'push',
                         'whatsapp'
                     )              NOT NULL DEFAULT 'push',
    leida            BOOLEAN         NOT NULL DEFAULT FALSE,
    fecha_hora       TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_notificacion        PRIMARY KEY (id_notificacion),
    CONSTRAINT FK_notif_usuario       FOREIGN KEY (id_usuario)
        REFERENCES USUARIO (id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_notif_cuidador      FOREIGN KEY (id_cuidador)
        REFERENCES CUIDADOR (id_cuidador)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Notificaciones enviadas a cuidadores';


-- ============================================================
-- ÍNDICES ADICIONALES PARA RENDIMIENTO
-- ============================================================
CREATE INDEX IDX_prescripcion_usuario     ON PRESCRIPCION   (id_usuario);
CREATE INDEX IDX_prescripcion_medicamento ON PRESCRIPCION   (id_medicamento);
CREATE INDEX IDX_horario_prescripcion     ON HORARIO_TOMA   (id_prescripcion);
CREATE INDEX IDX_registro_usuario         ON REGISTRO_TOMA  (id_usuario);
CREATE INDEX IDX_registro_programada      ON REGISTRO_TOMA  (fecha_hora_programada);
CREATE INDEX IDX_registro_estado          ON REGISTRO_TOMA  (estado);
CREATE INDEX IDX_notificacion_leida       ON NOTIFICACION   (leida);
CREATE INDEX IDX_notificacion_cuidador    ON NOTIFICACION   (id_cuidador);
CREATE INDEX IDX_inventario_cantidad      ON INVENTARIO     (cantidad_actual);
CREATE INDEX IDX_alarma_activo            ON ALARMA         (activo);


-- ------------------------------------------------------------
-- Reactivar revisión de claves foráneas
-- ------------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 1;


-- ============================================================
-- DATOS DE PRUEBA (semilla básica)
-- ============================================================

INSERT INTO USUARIO (nombre, apellido, fecha_nacimiento, email, telefono, contrasena_hash)
VALUES
    ('María', 'García López',    '1955-03-12', 'maria.garcia@correo.com',  '6561234567', SHA2('clave123', 256)),
    ('Juan',  'Rodríguez Pérez', '1948-07-28', 'juan.rodriguez@correo.com','6569876543', SHA2('clave456', 256));

INSERT INTO PERFIL_MEDICO (id_usuario, peso, altura, alergias, condiciones_cronicas, grupo_sanguineo)
VALUES
    (1, 62.5, 1.58, 'Penicilina',  'Hipertensión, Diabetes tipo 2', 'A+'),
    (2, 80.0, 1.72, 'Ninguna',     'Insuficiencia cardíaca',         'O-');

INSERT INTO MEDICO (nombre, apellido, especialidad, cedula_profesional, email)
VALUES
    ('Carlos',  'Mendoza Ríos',   'Cardiología',        'MED-001-CJ', 'cmendoza@clinica.com'),
    ('Ana',     'Flores Sánchez', 'Medicina interna',   'MED-002-CJ', 'aflores@clinica.com');

INSERT INTO MEDICAMENTO (nombre_comercial, nombre_generico, presentacion, concentracion, unidad_medida)
VALUES
    ('Losartán 50',   'Losartán potásico', 'pastilla',  '50mg',   'mg'),
    ('Metformina 850','Metformina HCl',    'pastilla',  '850mg',  'mg'),
    ('Atorvastatina', 'Atorvastatina',     'pastilla',  '40mg',   'mg'),
    ('Furosemida 40', 'Furosemida',        'pastilla',  '40mg',   'mg');

INSERT INTO PRESCRIPCION (id_usuario, id_medicamento, id_medico, dosis, unidad_dosis, fecha_inicio, indicaciones)
VALUES
    (1, 1, 1, 1, 'pastilla', '2026-01-01', 'Tomar por la mañana en ayunas'),
    (1, 2, 2, 1, 'pastilla', '2026-01-01', 'Tomar con alimentos'),
    (2, 3, 1, 1, 'pastilla', '2026-02-01', 'Tomar por la noche'),
    (2, 4, 1, 1, 'pastilla', '2026-02-01', 'Tomar por la mañana');

INSERT INTO HORARIO_TOMA (id_prescripcion, hora, dias_semana, con_alimentos)
VALUES
    (1, '08:00:00', 'L,M,X,J,V,S,D', FALSE),
    (2, '13:00:00', 'L,M,X,J,V,S,D', TRUE),
    (3, '21:00:00', 'L,M,X,J,V,S,D', FALSE),
    (4, '08:00:00', 'L,M,X,J,V,S,D', FALSE);

INSERT INTO DISPOSITIVO (id_usuario, numero_serie, modelo, firmware_version, fecha_activacion)
VALUES
    (1, 'RP-2026-000001', 'PastilleroWatch Pro v2', '2.1.4', '2026-01-05'),
    (2, 'RP-2026-000002', 'PastilleroWatch Pro v2', '2.1.4', '2026-02-10');

INSERT INTO COMPARTIMENTO (id_dispositivo, id_medicamento, numero_slot, etiqueta, capacidad_unidades)
VALUES
    (1, 1, 1, 'Losartán AM',    30),
    (1, 2, 2, 'Metformina PM',  30),
    (2, 3, 1, 'Atorva noche',   30),
    (2, 4, 2, 'Furosemida AM',  30);

INSERT INTO INVENTARIO (id_compartimento, cantidad_actual, fecha_caducidad_lote, alerta_stock_minimo)
VALUES
    (1, 25, '2026-12-31', 5),
    (2, 18, '2026-11-30', 5),
    (3, 28, '2027-01-31', 5),
    (4,  8, '2026-10-31', 5);

INSERT INTO ALARMA (id_horario, id_dispositivo, tipo_alerta, anticipacion_min, repetir_cada_min)
VALUES
    (1, 1, 'sonido',    5, 10),
    (2, 1, 'vibracion', 0, 5),
    (3, 2, 'sonido',    5, 10),
    (4, 2, 'todos',     5, 5);

INSERT INTO CUIDADOR (id_usuario, nombre, relacion, email, telefono, puede_ver_historial)
VALUES
    (1, 'Pedro García',    'hijo',      'pedro.garcia@correo.com',    '6561112233', TRUE),
    (2, 'Laura Rodríguez', 'hija',      'laura.rodriguez@correo.com', '6564445566', TRUE);

INSERT INTO NOTIFICACION (id_usuario, id_cuidador, tipo_evento, mensaje, canal)
VALUES
    (1, 1, 'toma_omitida',  'María no tomó su Losartán a las 08:00.',         'push'),
    (2, 2, 'stock_bajo',    'Stock de Furosemida bajo: quedan 8 pastillas.',   'sms');

INSERT INTO REGISTRO_TOMA (id_horario, id_usuario, fecha_hora_programada, fecha_hora_real, estado, metodo_confirmacion)
VALUES
    (1, 1, '2026-05-11 08:00:00', '2026-05-11 08:03:00', 'tomada',   'sensor'),
    (2, 1, '2026-05-11 13:00:00', '2026-05-11 13:15:00', 'retrasada','manual'),
    (3, 2, '2026-05-11 21:00:00', NULL,                  'omitida',  NULL),
    (4, 2, '2026-05-11 08:00:00', '2026-05-11 08:01:00', 'tomada',   'sensor');


-- ============================================================
-- FIN DEL SCRIPT  — BD_reloj_pastillero
-- ============================================================
