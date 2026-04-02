Feature: Run a shell command
  Scenario: Shell command runs in the checked-out repository root
    Given a workflow is running inside a sandbox
    When the workflow calls `adk.shell("pwd")`
    Then the command should run in the checked-out project root by default

  Scenario: Non-zero exit fails the shell call
    Given a workflow is running inside a sandbox
    When the workflow calls `adk.shell("exit 1")`
    Then ADK should fail the shell call
