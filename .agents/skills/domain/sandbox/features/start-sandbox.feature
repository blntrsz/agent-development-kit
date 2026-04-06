Feature: Start sandbox
  Scenario: Selected sandbox starts before execution
    Given a run selects the `triage` sandbox
    And the sandbox image does not exist yet
    When ADK starts the run
    Then ADK should start the `triage` sandbox before execution
    And ADK should build the `triage` sandbox first

  Scenario: Default sandbox starts for runs without an explicit sandbox
    Given a run does not select a named sandbox
    And the default sandbox image does not exist yet
    When ADK starts the run
    Then ADK should start the default sandbox before execution
    And ADK should build the default sandbox first
