Feature: Validate workflow input and output
  Scenario: Input is validated before `run`
    Given a workflow defines an `input` schema
    And the provided args do not satisfy that schema
    When ADK starts the workflow
    Then ADK should fail validation
    And ADK should not call `run`

  Scenario: Output is validated before success
    Given a workflow defines an `output` schema
    And `run` resolves with a value that does not satisfy that schema
    When ADK completes the workflow
    Then ADK should fail validation
    And ADK should not mark the workflow as successful
