Feature: Define a sandbox
  Scenario: Sandbox is declared from a Dockerfile
    Given a project contains `.adk/sandbox/triage/Dockerfile`
    When ADK loads sandboxes
    Then ADK should register a sandbox named `triage`

  Scenario: Sandbox image includes ADK
    Given a sandbox Dockerfile is used for workflow execution
    When the sandbox image is built
    Then the image should include ADK

  Scenario: Default sandbox is required when no workflow sandbox is set
    Given a workflow does not declare `sandbox`
    When ADK resolves the workflow
    Then ADK should require `.adk/sandbox/default/Dockerfile`
