Feature: Default to local execution
  Scenario: Local mode is the default
    Given the user runs `adk run triage`
    When ADK starts execution
    Then ADK should run locally in Docker

  Scenario: Remote mode is selected explicitly
    Given the user runs `adk run triage --remote`
    When ADK starts execution
    Then ADK should run remotely on ECS
