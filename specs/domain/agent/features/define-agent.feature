Feature: Define an agent
  Scenario: Agent is declared from a file in `.adk/agents`
    Given a project contains `.adk/agents/triage-bot.ts`
    And the file default-exports `defineAgent(...)`
    When ADK loads agents
    Then ADK should register an agent named `triage-bot`
    And the file name and `name` field should match
    And `.adk/agents/` should be treated as a flat directory in v1

  Scenario: Duplicate agent names are rejected
    Given two agent files declare the same `name`
    When ADK loads agents
    Then ADK should fail with a clear duplicate-agent error
