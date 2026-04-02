Feature: Return a structured shell result
  Scenario: `result` parses and validates JSON output
    Given a shell command prints valid JSON
    And the workflow calls `adk.shell(command, { result: schema })`
    When ADK completes the command
    Then ADK should parse stdout as JSON
    And ADK should validate it against the schema

  Scenario: There is no separate json mode
    Given a workflow wants structured shell output
    When the workflow uses `adk.shell(...)`
    Then the workflow should use `result`
    And ADK should not require a separate `{ json: true }` option
