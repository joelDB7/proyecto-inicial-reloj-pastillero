
# 📱 Plan de Implementación: Reloj Pastillero
**Aplicación Multiplataforma (Flutter + Firebase)**

---

## 1. ️ Herramientas y Entorno de Desarrollo
Para asegurar un flujo de trabajo profesional, se requiere la siguiente configuración:

*   **Editor de Código:** Visual Studio Code (VS Code).
*   **Framework:** Flutter (última versión estable).
*   **Backend:** Firebase (Console & CLI).
*   **Control de Versiones:** Git + GitHub/GitLab.
*   **Emuladores:** Android Studio (para emulador Android) y Xcode (para iOS, si estás en Mac).
*   **Herramienta de Diseño (Opcional):** Figma (para refinar los wireframes antes de pasar a Flutter).

---

## 2. 📁 Estructura de Carpetas del Proyecto
La organización del proyecto sigue una arquitectura limpia y escalable, separando responsabilidades por características (features).

```text
reloj_pastillero/
│
├── android/                          # Configuración nativa Android
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── kotlin/               # Código Kotlin nativo
│   │   │   ├── res/                  # Recursos (iconos, splash screen)
│   │   │   └── AndroidManifest.xml   # Permisos y configuración
│   │   └── build.gradle              # Dependencias Android
│   └── build.gradle
│
├── ios/                              # Configuración nativa iOS
│   ├── Runner/
│   │   ├── AppDelegate.swift
│   │   ├── Info.plist                # Permisos y configuración iOS
│   │   └── Assets.xcassets/          # Assets iOS
│   └── Podfile                       # Dependencias CocoaPods
│
├── lib/                              # CÓDIGO FUENTE PRINCIPAL
│   ├── main.dart                     # Punto de entrada de la app
│   ├── app.dart                      # Configuración principal (MaterialApp)
│   │
│   ├── config/                       # CONFIGURACIÓN GLOBAL
│   │   ├── routes/
│   │   │   ── app_router.dart       # Configuración de rutas/navegación
│   │   ├── theme/
│   │   │   ├── app_theme.dart        # Tema global (light/dark)
│   │   │   └── app_colors.dart       # Paleta de colores centralizada
│   │   └── constants/
│   │       ├── app_constants.dart    # Constantes generales
│   │       └── api_constants.dart    # URLs y configuraciones de API
│   │
│   ├── core/                         # NÚCLEO COMPARTIDO
│   │   ├── utils/
│   │   │   ├── validators.dart       # Validaciones de formularios
│   │   │   ├── date_utils.dart       # Utilidades de fecha/hora
│   │   │   ├── helpers.dart          # Funciones auxiliares
│   │   │   └── app_logger.dart       # Sistema de logs
│   │   ├── errors/
│   │   │   ├── exceptions.dart       # Excepciones personalizadas
│   │   │   └── failures.dart         # Manejo de fallos
│   │   ├── network/
│   │   │   └── network_info.dart     # Verificador de conexión
│   │   └── widgets/
│   │       ├── custom_button.dart    # Botón reutilizable
│   │       ├── custom_text_field.dart # Campo de texto reutilizable
│   │       ├── loading_indicator.dart # Indicador de carga
│   │       └── error_widget.dart     # Widget de error genérico
│   │
│   ├── features/                     # CARACTERÍSTICAS DE LA APP
│   │   │
│   │   ├── auth/                     # AUTENTICACIÓN
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── auth_remote_datasource.dart  # Llamadas a Firebase Auth
│   │   │   │   ├── models/
│   │   │   │   │   └── user_model.dart             # Modelo de usuario
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart   # Implementación repo
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user_entity.dart            # Entidad de dominio
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart        # Contrato del repo
│   │   │   │   └── usecases/
│   │   │   │       ├── login_usecase.dart
│   │   │   │       ├── register_usecase.dart
│   │   │   │       ├── logout_usecase.dart
│   │   │   │       └── reset_password_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── auth_provider.dart          # Provider de autenticación
│   │   │       ├── screens/
│   │   │       │   ├── login_screen.dart
│   │   │       │   ├── register_screen.dart
│   │   │       │   └── forgot_password_screen.dart
│   │   │       └── widgets/
│   │   │           ├── auth_form.dart
│   │   │           └── auth_buttons.dart
│   │   │
│   │   ├── medication/               # GESTIÓN DE MEDICAMENTOS
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── medication_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── medication_model.dart
│   │   │   │   │   └── alarm_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── medication_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── medication_entity.dart
│   │   │   │   │   └── alarm_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── medication_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_medications_usecase.dart
│   │   │   │       ├── add_medication_usecase.dart
│   │   │   │       ├── update_medication_usecase.dart
│   │   │   │       ├── delete_medication_usecase.dart
│   │   │   │       └── get_medication_by_id_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── medication_provider.dart
│   │   │       ├── screens/
│   │   │       │   ├── medication_list_screen.dart      # Lista principal
│   │   │       │   ├── medication_detail_screen.dart    # Detalle con alarmas
│   │   │       │   ├── add_medication_screen.dart       # Formulario crear
│   │   │       │   └── edit_medication_screen.dart      # Formulario editar
│   │   │       └── widgets/
│   │   │           ├── medication_card.dart
│   │   │           ├── alarm_tile.dart
│   │   │           ├── inventory_counter.dart
│   │   │           └── medication_form.dart
│   │   │
│   │   ├── alarm/                    # SISTEMA DE ALARMAS
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── alarm_local_datasource.dart      # Notificaciones locales
│   │   │   │   └── models/
│   │   │   │       └── notification_model.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── notification_entity.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── schedule_alarm_usecase.dart
│   │   │   │       ├── cancel_alarm_usecase.dart
│   │   │   │       └── request_permissions_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── alarm_provider.dart
│   │   │       └── widgets/
│   │   │           ├── alarm_toggle.dart
│   │   │           └── time_picker_custom.dart
│   │   │
│   │   ├── profile/                  # PERFIL DE USUARIO
│   │   │   ├── data/
│   │   │   │   └── datasources/
│   │   │   │       └── profile_remote_datasource.dart
│   │   │   ├── domain/
│   │   │   │   └── usecases/
│   │   │   │       ├── update_profile_usecase.dart
│   │   │   │       └── get_profile_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── profile_provider.dart
│   │   │       ├── screens/
│   │   │       │   └── profile_screen.dart
│   │   │       ── widgets/
│   │   │           ├── profile_header.dart
│   │   │           └── medication_summary.dart
│   │   │
│   │   └── history/                  # HISTORIAL DE TOMAS
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   ── history_remote_datasource.dart
│   │       │   └── models/
│   │       │       └── intake_model.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── intake_entity.dart
│   │       │   └── usecases/
│   │       │       ├── get_intake_history_usecase.dart
│   │       │       └── mark_as_taken_usecase.dart
│   │       └── presentation/
│   │           ├── providers/
│   │           │   └── history_provider.dart
│   │           ├── screens/
│   │           │   └── history_screen.dart
│   │           └── widgets/
│   │               ├── intake_card.dart
│   │               └── history_chart.dart
│   │
│   ├── shared/                       # RECURSOS COMPARTIDOS
│   │   ├── widgets/
│   │   │   ├── bottom_nav_bar.dart   # Barra de navegación inferior
│   │   │   ├── custom_app_bar.dart   # AppBar personalizada
│   │   │   └── empty_state.dart      # Widget para listas vacías
│   │   └── services/
│   │       ├── notification_service.dart    # Servicio de notificaciones
│   │       └── local_storage_service.dart   # SharedPreferences/Hive
│   │
│   └── injection_container.dart      # Inyección de dependencias
│
├── assets/                           # RECURSOS ESTÁTICOS
│   ├── images/
│   │   ├── logo.png
│   │   ├── splash_screen.png
│   │   └── illustrations/
│   ├── icons/
│   │   └── custom_icons/
│   ├── animations/
│   │   └── loading.json
│   └── fonts/
│       └── custom_fonts/
│
├── test/                             # PRuebas UNITARIAS
│   ├── features/
│   │   ├── auth/
│   │   ├── medication/
│   │   └── alarm/
│   └── core/
│
├── integration_test/                 # PRuebas DE INTEGRACIÓN
│   └── app_test.dart
│
├── web/                              # Configuración Web
│   ├── index.html
│   └── manifest.json
│
├── pubspec.yaml                      # Dependencias y configuración
├── analysis_options.yaml             # Reglas de análisis/linting
├── .gitignore                        # Archivos a ignorar en Git
├── README.md                         # Documentación del proyecto
└── firebase.json                     # Configuración de Firebase
```

---

## 3. 🎨 Estrategia UI/UX y Gestión de Colores
Basado en las capturas de pantalla proporcionadas, la aplicación sigue una estética limpia y funcional. La paleta se ha extraído directamente de los prototipos para garantizar fidelidad visual.

### **1. Paleta de Colores Definida**

| Elemento UI | Color Aproximado | Código Hex Sugerido | Descripción y Uso |
| :--- | :--- | :--- | :--- |
| **Fondo Principal** | Azul Cielo Suave | `#A8D8F8` | Color base de la mayoría de las pantallas. Transmite calma y limpieza. |
| **AppBar (Header)** | Azul Oscuro Profundo | `#154394` | Barra superior en pantallas de datos (como "Alarma"). Transmite autoridad y estructura. |
| **AppBar (Perfil)** | Blanco | `#FFFFFF` | Área superior en la pantalla de "Mi Perfil", creando un contraste limpio con el fondo azul. |
| **Tarjetas / Cards** | Blanco Puro | `#FFFFFF` | Contenedores para listas de medicamentos, datos de usuario y formularios. Bordes redondeados. |
| **Botones Secundarios** | Amarillo Brillante | `#F5E642` | Botones de acción rápida como "Editar", "Medicamentos" y el botón flotante "+". |
| **Botones Principales** | Verde Estándar | `#4CAF50` | Botones de confirmación o navegación interna como "Tono de alarmas" y "Ver historial". |
| **Texto en Botones** | Negro / Gris Oscuro | `#000000` | **Importante:** Tanto en los botones amarillos como en los verdes, el texto se mantiene oscuro para garantizar la legibilidad. |
| **Barra Inferior** | Blanco | `#FFFFFF` | Fondo de la navegación inferior (BottomNavigationBar). |
| **Iconos Inferiores** | Negro | `#000000` | Iconos de la barra de navegación para máximo contraste sobre el fondo blanco. |

### **2. Reglas de Aplicación de Estilo**
Para que el desarrollo sea consistente, se seguirán estas reglas derivadas de las imágenes:

*   **Contraste de Texto en Botones:** A diferencia de muchos diseños modernos que usan texto blanco sobre botones de color, en este prototipo se observa **texto negro** sobre los botones Amarillos y Verdes. Esto debe respetarse estrictamente.
*   **Bordes Redondeados:** Todas las tarjetas blancas (contenedores de medicamentos, perfil) y los botones (especialmente los verdes) tienen esquinas redondeadas (Border Radius aproximado de 12px a 20px).
*   **Jerarquía de Encabezados:**
    *   *Pantallas de Listado:* Usan el encabezado Azul Oscuro con texto Blanco (ej. "Joel Delgado 6j").
    *   *Pantallas de Perfil:* Usan un encabezado Blanco con texto Negro e Icono, integrado visualmente con el fondo Azul Cielo.
*   **Etiquetas de Sección:** Se utilizan etiquetas rectangulares de color Amarillo con texto negro para destacar títulos de secciones dentro del contenido (ej. la etiqueta "Medicamentos").

### **3. Configuración Centralizada (`app_colors.dart`)**
Al momento de programar, el archivo de configuración de colores debe definirse con estas constantes exactas:

*   `backgroundColor`: Color(0xFFA8D8F8)
*   `primaryAppBarColor`: Color(0xFF154394)
*   `cardColor`: Color(0xFFFFFFFF)
*   `secondaryButtonColor`: Color(0xFFF5E642)
*   `primaryButtonColor`: Color(0xFF4CAF50)
*   `textOnColoredButtons`: Color(0xFF000000)
*   `bottomNavBarBackground`: Color(0xFFFFFFFF)

---

## 4.  Dependencias (`pubspec.yaml`)
A continuación, se listan las librerías necesarias y su función, sin código:

*   **Core:**
    *   `flutter`: SDK base.
    *   `cupertino_icons`: Iconos estilo iOS.
*   **Backend (Firebase):**
    *   `firebase_core`: Inicialización de Firebase.
    *   `firebase_auth`: Manejo de Login, Registro y Sesión.
    *   `cloud_firestore`: Base de datos NoSQL en tiempo real.
*   **Gestión de Estado:**
    *   `provider`: Para manejar el estado global de la app (usuario logueado, lista de medicamentos) de forma sencilla.
*   **Notificaciones y Alarmas:**
    *   `flutter_local_notifications`: Para mostrar las alertas de toma de pastillas.
    *   `timezone` & `flutter_native_timezone`: Para manejar horarios locales precisos.
    *   `permission_handler`: Para pedir permisos de notificación al usuario.
*   **UI y Utilidades:**
    *   `intl`: Para formatear fechas y horas (ej. 08:00 AM).
    *   `image_picker`: Si se desea agregar fotos de las pastillas.
    *   `google_fonts`: Para tipografías personalizadas.

---

## 5. 🗄️ Estructura de Base de Datos (Firestore)
Se diseñará una base de datos NoSQL con la siguiente jerarquía lógica:

1.  **Colección `users`:**
    *   Documento con el ID del usuario.
    *   Campos: `nombre`, `email`, `foto_perfil` (opcional).
2.  **Sub-colección `medications` (dentro de cada usuario):**
    *   Documento por cada medicamento.
    *   Campos:
        *   `nombre` (ej. Ibuprofeno).
        *   `inventario_inicial` (ej. 10).
        *   `inventario_actual`.
        *   `activo` (booleano).
3.  **Sub-colección `alarms` (dentro de cada medicamento):**
    *   Documento por cada horario.
    *   Campos:
        *   `hora` (timestamp o string).
        *   `dias_semana` (array: L, M, X, J, V, S, D).
        *   `tomada` (booleano para el historial).

---

## 6. 📅 Plan de Desarrollo Paso a Paso
Este es el procedimiento cronológico para construir la aplicación.

### **Fase 1: Configuración Inicial**
1.  Crear proyecto en Flutter desde VS Code.
2.  Crear proyecto en Firebase Console.
3.  Descargar archivos de configuración (`google-services.json` para Android, `GoogleService-Info.plist` para iOS) y colocarlos en sus carpetas correspondientes.
4.  Configurar `pubspec.yaml` con las dependencias mencionadas.
5.  Configurar la navegación base (BottomNavigationBar).

### **Fase 2: Autenticación y Seguridad**
1.  Habilitar "Email/Password" en Firebase Authentication.
2.  Diseñar pantalla de Login y Registro.
3.  Implementar lógica de autenticación (crear usuario, iniciar sesión, cerrar sesión).
4.  Proteger las rutas: si no hay usuario logueado, redirigir siempre al Login.

### **Fase 3: Desarrollo de UI (Pantallas)**
1.  **Pantalla de Perfil:** Implementar la vista con el nombre, lista de medicamentos y botones verdes.
2.  **Pantalla de Medicamentos (Lista):** Crear la vista principal donde se ven las tarjetas de los medicamentos.
3.  **Pantalla de Detalle/Alarma:** Implementar la vista donde se ven los horarios específicos (08:00 AM, 10:00 AM) con los switches.
4.  **Pantalla de Edición/Creación:** Formulario para agregar nuevo medicamento (Nombre, Fecha, Hora, Inventario).

### **Fase 4: Lógica de Negocio (Provider + Firestore)**
1.  Crear `AuthProvider` para manejar el estado del usuario.
2.  Crear `MedicationProvider` para manejar la carga, creación y edición de medicamentos desde Firestore.
3.  Conectar los formularios de la UI para que guarden datos en la nube.
4.  Implementar la lógica de "Inventario": restar 1 cuando se marca como "tomada".

### **Fase 5: Sistema de Notificaciones (El "Reloj")**
1.  Configurar permisos de notificación en Android y iOS.
2.  Programar las notificaciones locales basadas en los horarios guardados en Firestore.
3.  Asegurar que la notificación se repita (ej. diario) según la configuración.
4.  Implementar el sonido personalizado ("Tono de alarmas").

### **Fase 6: Pruebas y Despliegue**
1.  **Testing:** Probar en un emulador y en un dispositivo físico. Verificar que las alarmas suenen incluso si la app está cerrada.
2.  **Optimización:** Revisar que la app no consuma demasiada batería.
3.  **Build:** Generar APK (Android) o IPA (iOS) para distribución.

---

## 7. 📊 Gestión del Proyecto
Para mantener el orden durante el desarrollo:

*   **Control de Versiones (Git):**
    *   Rama `main`: Código estable y listo para producción.
    *   Rama `dev`: Donde se integra el trabajo diario.
    *   Ramas `feature/nombre`: Para tareas específicas (ej. `feature/login`, `feature/alarms`).
*   **Metodología:** Kanban simple (To Do, In Progress, Done).
*   **Documentación:** Mantener este plan actualizado si surgen cambios.

*   ## promttt
*   Actúa como un Desarrollador Senior de Flutter y Arquitecto de Soluciones Cloud para construir la aplicación "Reloj Pastillero", una solución multiplataforma de gestión de salud avanzada. Tu objetivo es guiarme en el desarrollo siguiendo una arquitectura limpia (Clean Architecture) y el patrón de diseño por capas (Data, Domain, Presentation), utilizando Firebase (Auth y Firestore) y Provider para la gestión de estado. La interfaz debe ser estrictamente fiel a la siguiente identidad visual: fondo color Azul Cielo (#A8D8F8), AppBar Azul Oscuro Profundo (#154394), botones de acción en Amarillo Brillante (#F5E642) y Verde Estándar (#4CAF50), siempre con texto en color negro (#000000) para legibilidad, y tarjetas blancas con bordes redondeados (Radius 20px). El desarrollo se ejecutará bajo este plan detallado: 1. Configuración de Entorno: Genera el archivo 'pubspec.yaml' con las dependencias 'firebase_core', 'firebase_auth', 'cloud_firestore', 'provider', 'flutter_local_notifications', 'timezone', 'intl', 'google_fonts' y 'get_it'. 2. Sistema de Diseño: Crea 'lib/config/theme/app_colors.dart' y 'lib/config/theme/app_theme.dart' que configure globalmente el estilo de botones con texto negro, inputs y tipografía. 3. Modelado de Datos Relacional Completo: Basado específicamente en los diagramas ER proporcionados, implementa entidades y modelos con métodos 'fromFirestore' y 'toFirestore' para: 'Usuario' (datos base), 'Perfil_Medico' (peso, altura, alergias, condiciones crónicas, grupo sanguíneo), 'Medico' (especialidad, cédula), 'Prescripcion' (dosis, fecha inicio/fin, indicaciones), 'Medicamento' (nombre comercial/genérico, presentación, concentración), 'Dispositivo' (serie, modelo, firmware), 'Compartimento' (número de slot, etiqueta, capacidad), 'Horario_Toma' (hora, días semana, frecuencia), 'Registro_Toma' (fecha programada vs real, estado), 'Inventario' (cantidad actual por compartimento, fecha caducidad/recarga), 'Cuidador' (nombre, relación, teléfono) y 'Notificacion' (tipo evento, mensaje, leída). 4. Capa de Datos y Repositorios: Implementa las interfaces de repositorio que gestionen las llaves foráneas (FK) en Firestore, vinculando cada registro a su respectivo usuario y dispositivo. 5. Lógica de Negocio: Desarrolla el 'MedicationProvider' para el CRUD de prescripciones y un 'InventoryProvider' que descuente automáticamente el stock del 'Compartimento' correspondiente al confirmar una toma. 6. Sistema de Notificaciones Local: Configura 'NotificationService' para programar alertas basadas en 'Horario_Toma' y registrar el cumplimiento en 'Registro_Toma'. 7. Interfaz de Usuario: Construye las pantallas de Dashboard, Gestión de Compartimentos (slots), Perfil Médico e Historial, manteniendo el contraste de texto negro sobre botones amarillos/verdes. Al generar el código, incluye comentarios en español, utiliza tipado fuerte y asegura la integridad referencial según los diagramas. Empieza ahora con la fase 1 y 2 (Configuración y Tema).
