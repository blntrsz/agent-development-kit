Feature: Pass workflow args
  Scenario: Args are passed from `--args`
    Given the user runs `adk run triage --args '{"issueNumber":123}'`
    When ADK starts the workflow
    Then ADK should parse the JSON object
    And ADK should validate it against the workflow input schema
    And ADK should pass the parsed value to `run`

  Scenario: Missing args default to an empty object
    Given the user runs `adk run triage`
    When ADK starts the workflow
    Then ADK should pass `{}` as the workflow input
