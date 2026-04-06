Feature: Define default sandbox
  Scenario: Default sandbox comes from the default sandbox Dockerfile
    Given a project contains `.adk/sandbox/default/Dockerfile`
    When ADK resolves the default sandbox
    Then ADK should use that Dockerfile as the default sandbox definition

  Scenario: Missing default sandbox fails implicit fallback
    Given a project does not contain `.adk/sandbox/default/Dockerfile`
    And a run does not select a named sandbox
    When ADK resolves the sandbox
    Then ADK should fail with a clear missing-default-sandbox error
