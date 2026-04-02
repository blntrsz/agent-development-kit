Feature: Run from the project root
  Scenario: Project root is required
    Given the current working directory does not contain `.adk/`
    When the user runs `adk run triage`
    Then ADK should fail

  Scenario: ADK does not search parent directories in v1
    Given `.adk/` exists in a parent directory only
    When the user runs `adk run triage`
    Then ADK should fail instead of searching upward
