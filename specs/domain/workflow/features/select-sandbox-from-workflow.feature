Feature: Select a sandbox from a workflow
  Scenario: Workflow selects an explicit sandbox
    Given a workflow declares `sandbox: "triage"`
    And `.adk/sandbox/triage/Dockerfile` exists
    When ADK resolves the workflow
    Then ADK should select the `triage` sandbox

  Scenario: Workflow falls back to the default sandbox
    Given a workflow does not declare `sandbox`
    And `.adk/sandbox/default/Dockerfile` exists
    When ADK resolves the workflow
    Then ADK should select the `default` sandbox

  Scenario: Missing selected sandbox fails
    Given a workflow declares a sandbox that does not exist
    When ADK resolves the workflow
    Then ADK should fail with a clear missing-sandbox error
