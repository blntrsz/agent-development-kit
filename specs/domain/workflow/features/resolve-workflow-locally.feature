Feature: Resolve a workflow locally
  Scenario: Workflow is loaded from the local project
    Given the current working directory is the project root
    When the user runs `adk run triage`
    Then ADK should load `.adk/workflows/triage.ts`

  Scenario: Local workflow file is required even for remote runs
    Given the current working directory is the project root
    And `.adk/workflows/triage.ts` does not exist locally
    When the user runs `adk run triage --remote`
    Then ADK should fail before starting the remote run
