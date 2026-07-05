---
inclusion: auto
---

# Testing Conventions

## Test Style

Follow the **GIVEN / WHEN / THEN** pattern for all domain and use case tests.

### Naming

- **`@DisplayName`**: Human-readable sentence using `GIVEN ... WHEN ... THEN ...`
- **Method name**: camelCase mirror of the display name — `givenX_whenY_thenZ`

### Structure

Each test method follows this layout:

```java
@DisplayName("GIVEN <precondition> WHEN <action> THEN <expected result>")
@Test
void given<Precondition>_when<Action>_then<ExpectedResult>() {
    // Build the object under test
    var subject = ...;

    // Execute the behavior
    var actual = subject.someMethod();

    // Assert using AssertJ
    assertThat(actual).isEqualTo(expected);
}
```

### Assertions

- Use **AssertJ** (`assertThat`) for all assertions. Avoid JUnit `assertEquals`/`assertTrue`.

### Test Data

- Use a `testdata` subpackage with a `*Testdata` utility class for reusable builders.

### Frameworks

- **JUnit 5** for test lifecycle
- **AssertJ** for fluent assertions
- **Mockito** for mocking dependencies in use case tests
- **Instancio** for test data generation
- **Testcontainers** for integration tests requiring PostgreSQL
