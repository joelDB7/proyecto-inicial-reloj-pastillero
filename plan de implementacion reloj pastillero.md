# 📋 Plan de Implementación: Aplicación "Reloj Pastillero"
**Stack:** Flutter + Dart + Firebase (Auth + Firestore) + Provider  
**Entorno:** VS Code (o Android Studio) | **Formato:** Procedimiento paso a paso (sin código)

---

## 🛠️ 1. Herramientas Requeridas
| Categoría | Herramienta | Propósito |
|-----------|-------------|-----------|
| **IDE** | VS Code + Extensiones: `Flutter`, `Dart`, `Firebase`, `Error Lens`, `Pubspec Assist` | Desarrollo, depuración, gestión de paquetes |
| **SDK** | Flutter SDK ≥ 3.16, Dart SDK ≥ 3.2 | Framework base y lenguaje |
| **Backend/Cloud** | Firebase Console, Firebase CLI | Autenticación, base de datos, mensajería |
| **Control de Versiones** | Git + GitHub/GitLab | Historial, colaboración, CI/CD |
| **Diseño UI/UX** | Figma o Penpot | Wireframes, prototipos interactivos, sistema de diseño |
| **Emulación/Pruebas** | Android Emulator, iOS Simulator, dispositivo físico | Validación multiplataforma |
| **Utilidades** | Android Studio SDK Manager, Xcode (solo macOS para iOS), `adb`, `flutter doctor` | Configuración de plataformas nativas |

> 💡 *Nota: "Antigravity" parece ser un error tipográfico. Si te referías a Android Studio, es totalmente compatible. El plan funciona igual en VS Code o Android Studio.*

---

## 🎨 2. Directrices UI/UX
- **Principios de diseño:** Claridad visual, accesibilidad (WCAG 2.1 AA), retroalimentación inmediata, consistencia en patrones de interacción.
- **Paleta cromática:** Tonos calmantes (azul sanitario, verde menta, gris neutro). Alto contraste para texto y botones de acción crítica.
- **Tipografía:** Jerarquía clara (títulos, subtítulos, cuerpo, notas). Tamaños escalables, soporte para texto dinámico del sistema.
- **Flujos principales:** 
  1. Onboarding → 2. Login/Registro → 3. Dashboard (próximas dosis) → 4. Agregar/Editar medicamento → 5. Confirmar toma → 6. Configuración/Perfil
- **Componentes clave:** Cards de medicamento, línea de tiempo/calendario, botones grandes de confirmación, estados visuales (✅ tomado, ⏳ pendiente, ❌ omitido), modales de edición, indicadores de carga/error.
- **Accesibilidad:** Soporte para lectores de pantalla, navegación por teclado/gestos, modo oscuro/claro, tolerancia a errores (deshacer acciones, confirmaciones claras).

---

## 📦 3. Dependencias Estratégicas (`pubspec.yaml`)
*(Listadas como referencia conceptual. Se recomienda usar siempre versiones estables verificadas con `flutter pub outdated`)*

- `firebase_core` → Inicialización y puente con Firebase
- `firebase_auth` → Login/registro con email y contraseña
- `cloud_firestore` → Almacenamiento y sincronización de datos
- `provider` → Gestión de estado reactivo y arquitectura MVVM
- `flutter_local_notifications` → Recordatorios programados en dispositivo
- `timezone` → Manejo preciso de zonas horarias y programación
- `intl` → Formateo de fechas, horas y números
- `shared_preferences` → Persistencia local de preferencias (tema, sonido, etc.)
- `go_router` *(opcional)* → Navegación declarativa y protegida por rutas
- `firebase_crashlytics` / `firebase_analytics` *(opcional)* → Monitoreo en producción

---

## 🏗️ 4. Arquitectura y Estructura del Proyecto
- **Patrón recomendado:** MVVM ligero con Provider (separación clara entre UI, lógica de negocio y datos)
- **Estructura de carpetas sugerida:**
  ```
  lib/
  ├── core/          (constantes, temas, utilidades, enrutamiento base)
  ├── data/          (modelos, repositorios, servicios Firebase)
  ├── domain/        (casos de uso, interfaces de repositorio, validaciones)
  ├── presentation/  (pantallas, widgets reutilizables, providers, estado)
  └── utils/         (formateadores, validadores, helpers de notificación)
  ```
- **Principio:** La UI nunca accede directamente a Firebase. Usa repositorios → providers → widgets.

---

## 📅 5. Procedimiento Paso a Paso (Plan de Implementación)

### 🔹 Fase 1: Configuración del Entorno y Proyecto
1. Verificar instalación con `flutter doctor` y corregir dependencias faltantes.
2. Crear nuevo proyecto Flutter en VS Code (`Flutter: New Project`).
3. Crear proyecto en Firebase Console y registrar apps para Android, iOS y Web.
4. Descargar y ubicar archivos de configuración (`google-services.json`, `GoogleService-Info.plist`).
5. Habilitar **Authentication** (proveedor Email/Password) y **Firestore Database** en modo prueba temporal.
6. Ejecutar la app en emulador/dispositivo para validar build básico.

### 🔹 Fase 2: Diseño UI/UX y Prototipado
1. Crear wireframes de baja fidelidad en Figma para cada flujo principal.
2. Definir sistema de diseño: tokens de color, tipografía, espaciado, radios, elevaciones.
3. Disear pantallas de alta fidelidad: Login, Registro, Dashboard, Formulario Medicamento, Configuración.
4. Prototipar interacciones clave: transiciones, estados de carga, validaciones visuales, flujo de recordatorios.
5. Validar usabilidad con 3-5 usuarios objetivo (simulado o real). Ajustar antes de codificar.

### 🔹 Fase 3: Integración de Dependencias y Configuración Inicial
1. Añadir dependencias listadas en `pubspec.yaml`.
2. Ejecutar `flutter pub get` y resolver conflictos si existen.
3. Inicializar Firebase en el punto de entrada de la app.
4. Configurar permisos nativos para notificaciones (AndroidManifest, Info.plist).
5. Establecer estructura de carpetas y enrutamiento base (rutas públicas vs protegidas).

### 🔹 Fase 4: Autenticación y Gestión de Sesión
1. Implementar pantallas de Login y Registro con validación de campos.
2. Conectar con Firebase Auth: creación de cuenta, inicio de sesión, cierre, recuperación de contraseña.
3. Crear `AuthProvider` para exponer estado: `isLoading`, `user`, `error`, métodos `signIn`, `signUp`, `signOut`.
4. Gestionar redirección automática: usuario autenticado → Dashboard, no autenticado → Login.
5. Implementar manejo de errores amigable (credenciales incorrectas, email ya registrado, contraseña débil).

### 🔹 Fase 5: Base de Datos y Modelado de Datos
1. Diseñar estructura en Firestore:
   - Colección `users/{uid}/medications/{medId}`
   - Campos: nombre, dosis, frecuencia, horarios, fecha inicio/fin, notas, estado activo
   - Subcolección `logs` o campo `lastTaken` para historial
2. Crear modelos Dart con serialización/deserialización.
3. Implementar `MedicationRepository` con métodos: `getMedications`, `addMedication`, `updateMedication`, `deleteMedication`, `logIntake`.
4. Probar operaciones CRUD con datos ficticios y validar reglas de seguridad básicas.

### 🔹 Fase 6: Gestión de Estado con Provider
1. Crear providers especializados: `AuthProvider`, `MedicationProvider`, `NotificationSettingsProvider`.
2. Vincular providers a la UI mediante `MultiProvider` en la raíz.
3. Implementar estados derivados: `isLoading`, `isEmpty`, `hasError`, `data`.
4. Optimizar rebuilds: usar `select`, evitar `Provider.of(context)` innecesarios, extraer widgets a archivos separados.
5. Añadir manejo de errores globales y snackbars/toasts para feedback.

### 🔹 Fase 7: Desarrollo de Funcionalidades Core
1. **Dashboard:** Lista ordenada por próxima dosis, filtros por día/estado, indicador de progreso diario.
2. **Agregar/Editar medicamento:** Formulario con validación, selector múltiple de horarios, frecuencia (diaria, semanal, personalizada), notas opcionales.
3. **Confirmar toma:** Botón de acción, actualización inmediata en Firestore, cambio de estado visual, opción de posponer o marcar como omitido.
4. **Historial/Resumen:** Vista semanal/mensual, porcentaje de adherencia, exportación básica (opcional).
5. **Configuración:** Perfil de usuario, preferencias de notificación (sonido, vibración, anticipación), tema claro/oscuro, cierre de sesión.

### 🔹 Fase 8: Sistema de Recordatorios y Notificaciones
1. Configurar `flutter_local_notifications` con canales por prioridad (Android) y categorías (iOS).
2. Integrar `timezone` para programar notificaciones en zona horaria del dispositivo.
3. Implementar lógica de programación: convertir horarios de medicación a fechas futuras exactas.
4. Solicitar permisos críticos: `POST_NOTIFICATIONS` (Android 13+), permisos de alarmas exactas si aplica.
5. Probar escenarios: app en primer plano, segundo plano, cerrada, modo ahorro de energía, reinicio de dispositivo.
6. Añadir acciones en notificación: "Confirmar toma", "Posponer 15 min", "Ignorar".

### 🔹 Fase 9: Pruebas, Optimización y Despliegue
1. **Pruebas unitarias:** Validaciones de formulario, lógica de programación de notificaciones, transformación de datos.
2. **Pruebas de widget:** Renderizado de listas, estados de carga/error, navegación básica.
3. **Pruebas de integración:** Flujo completo: registro → agregar medicamento → recibir notificación → confirmar toma → verificar Firestore.
4. **Optimización:** Lazy loading de imágenes, reducir rebuilds, cache offline nativo de Firestore, manejo de desconexión.
5. **Preparación para producción:** Iconos adaptativos, splash screen, metadatos de tienda, generación de claves de firma, políticas de privacidad.
6. **Despliegue:** Subir a Firebase App Distribution (beta), luego a Google Play Console y App Store Connect. Seguir guías oficiales de revisión.

---

## 🔒 6. Consideraciones Transversales
- **Seguridad Firestore:** Reglas estrictas `request.auth != null && request.auth.uid == userId`. Validar datos en cliente y servidor (Cloud Functions si escala).
- **Privacidad y Cumplimiento:** Política de privacidad clara, consentimiento explícito, no almacenar datos sensibles sin encriptación, cumplir GDPR/Ley local.
- **Offline First:** Firestore maneja cache automático; diseñar UI que refleje estado `pending` cuando no hay conexión.
- **Mantenimiento:** Configurar CI/CD básico (GitHub Actions), integrar Crashlytics para monitoreo de errores, revisar dependencias trimestralmente.

---

✅ **Siguiente paso recomendado:** Validar este plan con tu equipo o revisarlo contra tus requisitos específicos de negocio. Una vez aprobado, puedes comenzar por la **Fase 1** y avanzar iterativamente, entregando un incremento funcional al final de cada fase. Si necesitas profundizar en alguna fase, reglas de Firestore, flujos de notificación o arquitectura de providers, indícalo y lo detallamos sin código.
