Feature: Require deploy before remote run
  Scenario: Remote run fails before deploy
    Given the repository has not been deployed remotely
    When the user runs `adk run triage --remote`
    Then ADK should fail
    And ADK should instruct the user to run `adk deploy remote` first
