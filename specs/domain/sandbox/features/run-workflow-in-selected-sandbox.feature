Feature: Run a workflow in the selected sandbox
  Scenario: Sandbox defines the whole workflow runtime
    Given a workflow selects a sandbox
    When ADK runs the workflow
    Then the workflow runtime should execute inside that sandbox
    And the sandbox should define more than just `adk.shell()` subprocess behavior

  Scenario: Repository is materialized in the sandbox workspace
    Given ADK starts a workflow inside a sandbox
    When the workflow begins
    Then the checked-out repository should exist inside the sandbox workspace
