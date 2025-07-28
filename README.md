# Docker Compose - Challenge Titan OS

This file contains instructions to run the Rails application with PostgreSQL using Docker Compose.

## Prerequisites

- Docker
- Docker Compose
- Configured `.env` file (already created)

## Configuration

### 1. Environment Variables

Make sure your `.env` file contains the following variables:

```bash
RAILS_MASTER_KEY=your_master_key_here
# PostgreSQL configuration
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_HOST=localhost
DATABASE_PORT=5432
```

### 2. Master Key

Get your `RAILS_MASTER_KEY` from the `config/master.key` file or generate a new one:

```bash
rails credentials:edit
```

## Usage

### Start services

```bash
docker compose up -d
```

### View logs in real time

```bash
docker compose logs -f
```

### View logs for a specific service

```bash
docker compose logs -f web    # For the Rails application
docker compose logs -f db     # For PostgreSQL
```

### Execute Rails commands

```bash
# Run migrations
docker compose exec web rails db:migrate

# Create database
docker compose exec web rails db:create

# Run seeds
docker compose exec web rails db:seed

# Open Rails console
docker compose exec web rails console

### Stop services
docker compose down
```

### Stop and remove volumes (warning: this will delete database data)

```bash
docker compose down -v
```

### Rebuild images

```bash
docker compose build --no-cache
```

## Application Access

- **Rails Application**: http://localhost:3000
- **PostgreSQL**: localhost:5432
  - User: postgres
  - Password: password
  - Database: challenge_titan_os_development

## File Structure

- `docker compose.yml`: Main Docker Compose configuration
- `Dockerfile.dev`: Development-specific Dockerfile
- `init.sql`: PostgreSQL initialization script
- `.env`: Environment variables (created by you)

## Troubleshooting

### If the application doesn't connect to the database

1. Verify that PostgreSQL is running:
   ```bash
   docker compose ps
   ```

2. Check PostgreSQL logs:
   ```bash
   docker compose logs db
   ```

3. Run migrations:
   ```bash
   docker compose exec web rails db:migrate
   ```

### If you need to restart everything from scratch

```bash
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

### If there are issues with gems

```bash
docker compose exec web bundle install
```

## Useful Commands

```bash
# View container status
docker compose ps

# Enter the application container
docker compose exec web bash

# Enter the PostgreSQL container
docker compose exec db psql -U postgres -d challenge_titan_os_development

# View resource usage
docker stats
```

## Testing

### Running Tests

The application includes comprehensive test coverage. You can run tests in several ways:

#### Option 1: Using the provided scripts (Recommended)

```bash
# Full setup (starts Docker if needed)
./bin/test
```

#### Option 2: Manual execution

```bash
# Set environment variables
export RAILS_ENV=test
export DATABASE_HOST=localhost
export DATABASE_USERNAME=postgres
export DATABASE_PASSWORD=postgres

# Create and migrate test database
bundle exec rails db:create RAILS_ENV=test
bundle exec rails db:migrate RAILS_ENV=test

# Run tests
bundle exec rspec
```

### Test Coverage

The test suite includes:
- **113 test examples** covering all major functionality
- Model validations and associations
- API endpoints (Contents, Search, Favorites)
- Services (Search, Content Filter, Favorites, etc.)
- Serializers
- Data import functionality

### Test Database

Tests use a separate PostgreSQL database (`challenge_titan_os_test`) that is:
- Created automatically by the test scripts
- Cleaned between test runs
- Isolated from development data
