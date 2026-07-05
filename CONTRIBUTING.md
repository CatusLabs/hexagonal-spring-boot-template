# Contributing

## Prerequisites

- Java 21+
- Maven 3.9+
- Docker & Docker Compose
- Node.js 20+ (for frontend)

## Building

```bash
./mvnw clean install
```

## Running locally

```bash
# Start infrastructure
docker compose up postgres -d

# Run the app
./mvnw -pl application spring-boot:run
```

## Releasing & Deployment

This project uses [Conventional Commits](https://www.conventionalcommits.org/) and Git tags.

### How to release

1. Ensure `main` is green.
2. Create and push a version tag:

```bash
git tag v1.0.0
git push origin v1.0.0
```

3. The Deploy workflow builds a Docker image and pushes to GHCR.

### Commit message conventions

- `fix: ...` → patch
- `feat: ...` → minor
- `feat!: ...` → major
- `chore:`, `docs:`, `refactor:` → no release
