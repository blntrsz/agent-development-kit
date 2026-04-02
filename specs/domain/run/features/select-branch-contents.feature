Feature: Select branch contents
  Scenario: Branch changes the checked-out repository contents
    Given the user runs `adk run triage --branch feature-x`
    When ADK prepares the repository inside the sandbox
    Then ADK should check out `feature-x`

  Scenario: Missing branch defaults to HEAD
    Given the user runs `adk run triage`
    When ADK prepares the repository inside the sandbox
    Then ADK should use `HEAD`

  Scenario: Branch does not change the selected sandbox
    Given the local workflow resolves to sandbox `triage`
    And the user runs `adk run triage --branch feature-x`
    When ADK prepares the run
    Then ADK should keep sandbox `triage`
