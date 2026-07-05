# Hexagonal Spring Boot Template

A template repository for bootstrapping hexagonal architecture (ports & adapters) Spring Boot 4 applications.

## Tech Stack

- **Java 21** (Temurin)
- **Spring Boot 4** with Maven multi-module build
- **PostgreSQL 16** with Flyway migrations
- **Spring AI 2.0** (Ollama local, OpenAI/Anthropic cloud)
- **OpenAPI 3.1** code generation with Springdoc
- **Angular 18+** frontend (Tailwind CSS 4, built via frontend-maven-plugin)
- **Lombok** for boilerplate reduction
- **JUnit 5 + AssertJ + Mockito + Instancio + Testcontainers**
- **ArchUnit** for architecture enforcement
- **Docker** with GitHub Container Registry deployment

## Quick Start

### 1. Use this template

Click **"Use this template"** on GitHub, or clone and reinitialize:

```bash
gh repo create my-org/my-app --template CatusLabs/hexagonal-spring-boot-template --public
cd my-app
```

### 2. Customize placeholders

Run the init script to replace all template placeholders:

```bash
./init-project.sh my-app com.myorg.myapp myorg
```

This replaces:
- `{{APP_NAME}}` → your app name (e.g., `my-app`)
- `{{APP_NAME_PASCAL}}` → PascalCase (e.g., `MyApp`)
- `{{GROUP_ID}}` → Maven groupId (e.g., `com.myorg.myapp`)
- `{{BASE_PACKAGE_PATH}}` → package path (e.g., `com/myorg/myapp`)
- `{{BASE_PACKAGE}}` → package name (e.g., `com.myorg.myapp`)
- `{{ORG_NAME}}` → GitHub org (e.g., `myorg`)

### 3. Build

```bash
./mvnw clean install
```

### 4. Run locally

```bash
docker compose up postgres -d
./mvnw spring-boot:run -pl application
```

## Architecture

```
application               ← Spring Boot entry point, wires all modules
├── {{app}}-api           ← REST adapter (controllers, OpenAPI codegen)
├── {{app}}-db            ← Persistence adapter (JPA, Flyway)
├── {{app}}-ui            ← Web UI adapter (Angular frontend)
├── {{app}}-filestore     ← File storage adapter (local FS / S3)
├── {{app}}-worker        ← Async pipeline orchestration
├── {{app}}-ai            ← Spring AI adapter (embeddings, RAG)
└── {{app}}-usecase       ← Business logic / use cases
    └── {{app}}-domain    ← Domain models, ports (interfaces)
        └── common-domain ← Shared domain abstractions
```

### Key Principles

- Domain and use case modules have **zero Spring dependencies** (pure Java)
- Adapters depend inward toward the domain
- ArchUnit tests enforce dependency rules at build time
- RFC 7807 ProblemDetail for error responses
- Records for immutable value objects
- Sealed interfaces for type-safe algebraic types

## Module Overview

| Module | Role | Spring dependency |
|---|---|---|
| `common-domain` | Shared validation, events, pagination | None |
| `common-adapter` | Shared adapter utilities | None |
| `{{app}}-domain` | Domain entities, repository ports | None |
| `{{app}}-usecase` | Use case implementations | Jakarta Transaction only |
| `{{app}}-api` | REST controllers, OpenAPI spec | Spring Web |
| `{{app}}-db` | JPA entities, repositories, migrations | Spring Data JPA |
| `{{app}}-ui` | Angular frontend | None (Maven plugin) |
| `{{app}}-filestore` | File storage | Spring Boot |
| `{{app}}-ai` | LLM classification, embeddings | Spring AI |
| `{{app}}-worker` | Async pipeline | Spring Boot |
| `application` | Boot app, config, profiles | Spring Boot |

## Common Commands

```bash
# Build and test everything
./mvnw clean install

# Run tests only
./mvnw clean verify

# Run locally
docker compose up postgres -d
./mvnw spring-boot:run -pl application

# Build a single module
./mvnw clean install -pl <module-name> -am

# Skip tests
./mvnw clean install -DskipTests
```

## CI/CD

Uses reusable workflows from `CatusLabs/cicd-tools`:
- **CI**: Runs on push to main and PRs → `./mvnw clean verify`
- **Deploy**: Triggered by `v*` tags → builds Docker image, pushes to GHCR

## License

MIT
