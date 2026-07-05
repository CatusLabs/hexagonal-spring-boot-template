---
inclusion: auto
---

# Project Structure

## Architecture

Hexagonal (Ports & Adapters) architecture. Domain and use case modules have zero Spring dependencies. Adapters depend inward toward the domain.

```
application            ← Spring Boot entry point, wires all modules
├── {{APP_NAME}}-api       ← REST adapter (controllers, OpenAPI codegen)
├── {{APP_NAME}}-db        ← Persistence adapter (JPA repositories, Flyway)
├── {{APP_NAME}}-ui        ← Web UI adapter (Angular frontend)
├── {{APP_NAME}}-filestore ← File storage adapter (local FS / S3)
├── {{APP_NAME}}-ai        ← Spring AI adapter
├── {{APP_NAME}}-worker    ← Async pipeline orchestration
└── {{APP_NAME}}-usecase   ← Business logic / use cases
    └── {{APP_NAME}}-domain ← Domain models, ports (interfaces)
        └── common-domain ← Shared domain abstractions
```

## Package Convention

`{{BASE_PACKAGE}}.{bounded-context}.{layer}`

## Key Patterns

- **UseCase suffix**: Classes ending in `UseCase` are auto-registered as Spring beans
- **Validation**: `Validator<T>` with composable `ValidationRule<T>` rules
- **Domain events**: `DomainEvent` / `DomainEventPublisher` interfaces
- **Pagination**: `PaginatedResult<T>` and `PaginationMetadata` records
- **Error responses**: RFC 7807 `ProblemDetail` via `GlobalExceptionHandler`
- **Records**: Used for immutable value objects
- **Sealed interfaces**: Used for type-safe algebraic types
