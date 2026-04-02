Feature: Run a prompt with an agent
  Scenario: Explicit agent is used
    Given a workflow calls `adk.prompt("hello", "triage-bot")`
    When ADK runs the prompt
    Then ADK should use the `triage-bot` agent

  Scenario: Default agent is used implicitly
    Given a workflow calls `adk.prompt("hello")`
    When ADK runs the prompt
    Then ADK should use the default agent
