# CashBank - Sistema de Gestión Financiera

Una aplicación bancaria móvil completa con arquitectura de microservicios que incluye gestión de usuarios, transacciones, tarjetas y generación de reportes PDF.

## 🏗️ Arquitectura del Sistema

El proyecto está dividido en tres componentes principales:

### 📱 Frontend (Flutter)
- **Framework**: Flutter/Dart
- **Funcionalidades**:
  - Autenticación de usuarios (login/registro)
  - Dashboard principal con saldo disponible
  - Gestión de pagos entre usuarios
  - Historial de transacciones con filtros
  - Gestión de tarjetas de crédito/débito
  - Descarga de reportes PDF
  - Navegación multi-pantalla

### ⚙️ Backend Java (Spring Boot)
- **Puerto**: 8080
- **Framework**: Spring Boot 3.4.2
- **Base de datos**: MySQL/H2 (para usuarios y tarjetas)
- **Funcionalidades**:
  - Gestión de usuarios (registro, login, perfil)
  - Autenticación JWT
  - Gestión de tarjetas
  - Actualización de balances
  - API REST

### 🐍 Backend Python (Flask)
- **Puerto**: 5000
- **Framework**: Flask
- **Base de datos**: MongoDB (para transacciones)
- **Funcionalidades**:
  - Gestión de transacciones
  - Generación de reportes PDF
  - Historial de transacciones
  - Comunicación con backend Java

## 🚀 Tecnologías Utilizadas

### Frontend
- **Flutter**: Framework de desarrollo móvil multiplataforma
- **Dart**: Lenguaje de programación
- **HTTP**: Cliente para comunicación con APIs
- **SharedPreferences**: Almacenamiento local
- **SVG**: Manejo de gráficos vectoriales

### Backend Java
- **Spring Boot**: Framework de aplicaciones Java
- **Spring Security**: Autenticación y autorización
- **JPA/Hibernate**: ORM para base de datos
- **JWT**: Tokens de autenticación
- **Maven**: Gestión de dependencias

### Backend Python
- **Flask**: Framework web ligero
- **MongoEngine**: ODM para MongoDB
- **CORS**: Manejo de políticas de intercambio de recursos
- **ReportLab**: Generación de PDFs
- **JWT**: Validación de tokens

### Base de Datos
- **MongoDB**: Base de datos NoSQL para transacciones
- **MySQL/H2**: Base de datos relacional para usuarios y tarjetas

## 📁 Estructura del Proyecto

```
Tarea2/
├── frontend/                 # Aplicación Flutter
│   ├── lib/
│   │   ├── controller/      # Controladores de lógica de negocio
│   │   ├── models/          # Modelos de datos
│   │   ├── services/        # Servicios de API
│   │   ├── views/           # Pantallas de la aplicación
│   │   ├── constants.dart   # URLs y constantes
│   │   ├── main.dart        # Punto de entrada
│   │   └── routes.dart      # Configuración de rutas
│   ├── assets/              # Recursos (imágenes, iconos)
│   └── pubspec.yaml         # Dependencias Flutter
│
├── banco java/               # Backend Spring Boot
│   └── banco/
│       ├── src/main/java/   # Código fuente Java
│       ├── src/test/java/   # Pruebas unitarias
│       ├── target/          # Archivos compilados
│       └── pom.xml          # Dependencias Maven
│
├── banco python/             # Backend Flask
│   ├── models/              # Modelos de datos MongoDB
│   ├── routes/              # Rutas de la API
│   ├── services/            # Servicios de negocio
│   ├── utils/               # Utilidades (generación PDF)
│   ├── app.py               # Aplicación principal Flask
│   └── config.py            # Configuración de la aplicación
│
└── docs/                     # Documentación del proyecto
    ├── Grupo1_informe3.1.pdf
    └── INFORME 3_1_.docx
```

## 🔧 Instalación y Configuración

### Prerrequisitos
- **Flutter SDK** (3.0+)
- **Java JDK** (17+)
- **Python** (3.8+)
- **MongoDB** (4.4+)
- **MySQL** (8.0+) o **H2** para desarrollo

### 1. Configuración del Frontend (Flutter)

```bash
cd frontend
flutter pub get
flutter run
```

### 2. Configuración del Backend Java

```bash
cd "banco java/banco"
./mvnw spring-boot:run
```

### 3. Configuración del Backend Python

```bash
cd "banco python"
pip install -r requirements.txt
python app.py
```

### 4. Configuración de Base de Datos

#### MongoDB (Transacciones)
```bash
# Iniciar MongoDB
mongod --port 27017

# Crear base de datos
use bankdb
```

#### MySQL (Usuarios y Tarjetas)
```sql
-- Crear base de datos
CREATE DATABASE bankdb;
```

## 🎯 Funcionalidades Principales

### 👤 Gestión de Usuarios
- Registro con validación de email (@dominio.com)
- Login con autenticación JWT
- Perfil de usuario con saldo disponible
- Balance inicial de $1000 para nuevos usuarios

### 💳 Gestión de Pagos
- Transferencias entre usuarios por email y tarjeta
- Validación de montos y disponibilidad de fondos
- Confirmación de transacciones
- Actualización automática de balances

### 📊 Historial de Transacciones
- Visualización de todas las transacciones
- Filtros por fecha y tipo de transacción
- Descarga de reportes en PDF
- Interfaz intuitiva con tarjetas

### 🏦 Gestión de Tarjetas
- Agregar nuevas tarjetas
- Congelar/descongelar tarjetas
- Eliminar tarjetas
- Gestión de tarjetas de crédito y débito

## 🔗 Endpoints de API

### Backend Java (Puerto 8080)
- `POST /users/register` - Registro de usuarios
- `POST /users/login` - Autenticación
- `GET /users/me` - Perfil de usuario
- `PUT /users/update-balance` - Actualizar balance
- `POST /cards/add` - Agregar tarjeta
- `GET /cards/user` - Obtener tarjetas del usuario

### Backend Python (Puerto 5000)
- `POST /transactions/add` - Crear transacción
- `GET /transactions/history` - Historial de transacciones
- `GET /transactions/history/pdf` - Generar PDF

## 🎨 Pantallas de la Aplicación

1. **Login**: Autenticación de usuarios
2. **Registro**: Creación de nuevas cuentas
3. **Dashboard**: Pantalla principal con balance y accesos rápidos
4. **Pagos**: Formulario para realizar transferencias
5. **Historial**: Lista de transacciones con filtros
6. **Tarjetas**: Gestión de tarjetas del usuario

## 👥 Equipo de Desarrollo

- **Desarrollo Frontend**: Flutter/Dart
- **Desarrollo Backend Java**: Spring Boot
- **Desarrollo Backend Python**: Flask
- **Base de Datos**: MongoDB & MySQL
- **Diseño UI/UX**: Material Design

## 📄 Licencia

Este proyecto es parte de un trabajo académico para el curso de Desarrollo de Aplicaciones Móviles.

## 🤝 Contribuciones

Para contribuir al proyecto:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📞 Soporte

Para soporte técnico o preguntas sobre el proyecto, contacta al equipo de desarrollo.

---

**Nota**: Este proyecto requiere que todos los servicios (Frontend, Backend Java, Backend Python y MongoDB) estén ejecutándose simultáneamente para un funcionamiento completo.
