Feature: Execute command in sandbox
  Scenario: Command is passed to the selected sandbox
    Given a run selects the `triage` sandbox
    When ADK sends the command `pwd` to the sandbox
    Then the command should execute inside the `triage` sandbox workspace

  Scenario: Command uses the default sandbox when none is selected
    Given a run does not select a named sandbox
    When ADK sends the command `pwd` to the sandbox
    Then the command should execute inside the default sandbox workspace
