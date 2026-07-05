package {{BASE_PACKAGE}}.architecture;

import com.tngtech.archunit.core.importer.ImportOption;
import com.tngtech.archunit.junit.AnalyzeClasses;
import com.tngtech.archunit.junit.ArchTest;
import com.tngtech.archunit.lang.ArchRule;

import static com.tngtech.archunit.lang.syntax.ArchRuleDefinition.noClasses;

@AnalyzeClasses(packages = "{{BASE_PACKAGE}}", importOptions = ImportOption.DoNotIncludeTests.class)
class HexagonalArchitectureTest {

    @ArchTest
    static final ArchRule domain_should_not_depend_on_spring =
        noClasses().that().resideInAnyPackage(
            "{{BASE_PACKAGE}}.common.domain..",
            "{{BASE_PACKAGE}}.domain..",
            "{{BASE_PACKAGE}}.usecase.."
        ).should().dependOnClassesThat().resideInAnyPackage(
            "org.springframework.."
        ).allowEmptyShould(true);

    @ArchTest
    static final ArchRule domain_should_not_depend_on_adapters =
        noClasses().that().resideInAnyPackage(
            "{{BASE_PACKAGE}}.domain..",
            "{{BASE_PACKAGE}}.usecase.."
        ).should().dependOnClassesThat().resideInAnyPackage(
            "{{BASE_PACKAGE}}.api..",
            "{{BASE_PACKAGE}}.ai..",
            "{{BASE_PACKAGE}}.filestore..",
            "{{BASE_PACKAGE}}.db..",
            "{{BASE_PACKAGE}}.worker.."
        ).allowEmptyShould(true);

    @ArchTest
    static final ArchRule db_adapter_should_not_depend_on_other_adapters =
        noClasses().that().resideInAnyPackage(
            "{{BASE_PACKAGE}}.db.."
        ).should().dependOnClassesThat().resideInAnyPackage(
            "{{BASE_PACKAGE}}.api..",
            "{{BASE_PACKAGE}}.ai..",
            "{{BASE_PACKAGE}}.filestore..",
            "{{BASE_PACKAGE}}.worker.."
        ).allowEmptyShould(true);

    @ArchTest
    static final ArchRule ai_adapter_should_not_depend_on_other_adapters =
        noClasses().that().resideInAnyPackage(
            "{{BASE_PACKAGE}}.ai.."
        ).should().dependOnClassesThat().resideInAnyPackage(
            "{{BASE_PACKAGE}}.api..",
            "{{BASE_PACKAGE}}.db..",
            "{{BASE_PACKAGE}}.filestore..",
            "{{BASE_PACKAGE}}.worker.."
        ).allowEmptyShould(true);
}
