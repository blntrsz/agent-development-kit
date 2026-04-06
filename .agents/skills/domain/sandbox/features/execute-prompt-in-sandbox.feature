Feature: Execute prompt in sandbox
  Scenario: Prompt runs inside the selected sandbox
    Given a run selects the `triage` sandbox
    When ADK executes the prompt `summarize the repo`
    Then the prompt should run inside the `triage` sandbox

  Scenario: Prompt uses the default sandbox when none is selected
    Given a run does not select a named sandbox
    When ADK executes the prompt `summarize the repo`
    Then the prompt should run inside the default sandbox
