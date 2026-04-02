Feature: Define a workflow
  Scenario: Workflow is declared from a file in `.adk/workflows`
    Given a project contains `.adk/workflows/triage.ts`
    And the file default-exports `defineWorkflow(...)`
    When ADK loads workflows
    Then ADK should register the workflow `triage`
    And `.adk/workflows/` should be treated as a flat directory in v1

  Scenario: Workflow name defaults to the file name
    Given a workflow file named `triage.ts`
    And the workflow does not set `name`
    When ADK loads the workflow
    Then the workflow name should be `triage`

  Scenario: Explicit workflow name must match the file name
    Given a workflow file named `triage.ts`
    And the workflow sets `name: "issue-triage"`
    When ADK loads the workflow
    Then ADK should fail with a clear workflow-name-mismatch error
