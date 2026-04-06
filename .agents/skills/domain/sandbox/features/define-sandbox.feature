Feature: Define sandbox
  Scenario: Named sandbox is declared from a sandbox Dockerfile
    Given a project contains `.adk/sandbox/triage/Dockerfile`
    When ADK loads sandboxes
    Then ADK should register a sandbox named `triage`

  Scenario: Sandbox Dockerfile defines the sandbox image
    Given a project contains `.adk/sandbox/triage/Dockerfile`
    When ADK resolves the `triage` sandbox
    Then ADK should use that Dockerfile as the sandbox definition
