---
inclusion: auto
---

# Tech Stack

## Core

- **Java 21** (Temurin distribution)
- **Spring Boot 4**
- **Maven** multi-module build with Maven Wrapper (`./mvnw`)
- **Lombok** for boilerplate reduction

## Database

- **PostgreSQL 16** (Docker Compose for local dev)
- **Spring Data JPA** with JPA auditing enabled
- **Flyway** for database migrations (migrations in `{{APP_NAME}}-db/src/main/resources/db/migration/`)

## AI

- **Spring AI 2.0** for LLM integration (Ollama local, OpenAI/Anthropic cloud)

## API

- **OpenAPI 3.1.0** spec for REST API documentation
- **Springdoc** for Swagger UI
- Uses `ProblemDetail` (RFC 7807) for error responses

## Frontend

- **Angular 18+** with Tailwind CSS 4
- Built via `frontend-maven-plugin`
- Source: `{{APP_NAME}}-ui/src/angular/`

## Testing

- **JUnit 5** + **AssertJ** + **Mockito**
- **Instancio** for test data generation
- **Testcontainers** for PostgreSQL integration tests

## CI/CD

- GitHub Actions: build → test (`./mvnw clean verify`), then Docker image push to `ghcr.io`

## Common Commands

```bash
# Build and test everything
./mvnw clean install

# Run tests only
./mvnw clean verify

# Run locally (requires PostgreSQL via Docker Compose)
docker compose up postgres -d
./mvnw spring-boot:run -pl application

# Build a single module
./mvnw clean install -pl <module-name> -am

# Skip tests
./mvnw clean install -DskipTests
```
