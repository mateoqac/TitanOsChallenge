# Docker Compose - Challenge Titan OS

Este archivo contiene las instrucciones para ejecutar la aplicación Rails con PostgreSQL usando Docker Compose.

## Requisitos Previos

- Docker
- Docker Compose
- Archivo `.env` configurado (ya creado)

## Configuración

### 1. Variables de Entorno

Asegúrate de que tu archivo `.env` contenga las siguientes variables:

```bash
RAILS_ENV=development
RAILS_MASTER_KEY=tu_master_key_aqui
DATABASE_URL=postgresql://postgres:password@db:5432/challenge_titan_os_development
RAILS_MAX_THREADS=5
WEB_CONCURRENCY=2

# Configuración de PostgreSQL
POSTGRES_DB=challenge_titan_os_development
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password
POSTGRES_HOST=db
POSTGRES_PORT=5432
```

### 2. Master Key

Obtén tu `RAILS_MASTER_KEY` del archivo `config/master.key` o genera una nueva:

```bash
rails credentials:edit
```

## Uso

### Iniciar los servicios

```bash
docker-compose up -d
```

### Ver logs en tiempo real

```bash
docker-compose logs -f
```

### Ver logs de un servicio específico

```bash
docker-compose logs -f web    # Para la aplicación Rails
docker-compose logs -f db     # Para PostgreSQL
```

### Ejecutar comandos Rails

```bash
# Ejecutar migraciones
docker-compose exec web rails db:migrate

# Crear la base de datos
docker-compose exec web rails db:create

# Ejecutar seeds
docker-compose exec web rails db:seed

# Abrir consola de Rails
docker-compose exec web rails console

# Ejecutar tests
docker-compose exec web rails test
```

### Detener los servicios

```bash
docker-compose down
```

### Detener y eliminar volúmenes (cuidado: esto eliminará los datos de la BD)

```bash
docker-compose down -v
```

### Reconstruir las imágenes

```bash
docker-compose build --no-cache
```

## Acceso a la Aplicación

- **Aplicación Rails**: http://localhost:3000
- **PostgreSQL**: localhost:5432
  - Usuario: postgres
  - Contraseña: password
  - Base de datos: challenge_titan_os_development

## Estructura de Archivos

- `docker-compose.yml`: Configuración principal de Docker Compose
- `Dockerfile.dev`: Dockerfile específico para desarrollo
- `init.sql`: Script de inicialización de PostgreSQL
- `.env`: Variables de entorno (creado por ti)

## Solución de Problemas

### Si la aplicación no se conecta a la base de datos

1. Verifica que PostgreSQL esté ejecutándose:
   ```bash
   docker-compose ps
   ```

2. Verifica los logs de PostgreSQL:
   ```bash
   docker-compose logs db
   ```

3. Ejecuta las migraciones:
   ```bash
   docker-compose exec web rails db:migrate
   ```

### Si necesitas reiniciar todo desde cero

```bash
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

### Si hay problemas con las gemas

```bash
docker-compose exec web bundle install
```

## Comandos Útiles

```bash
# Ver el estado de los contenedores
docker-compose ps

# Entrar al contenedor de la aplicación
docker-compose exec web bash

# Entrar al contenedor de PostgreSQL
docker-compose exec db psql -U postgres -d challenge_titan_os_development

# Ver el uso de recursos
docker stats
```
