Feature: Resolve the default agent
  Scenario: Prompt and skill use `default.ts`
    Given a project contains `.adk/agents/default.ts`
    And a workflow calls `adk.prompt(...)` without an explicit agent
    When the workflow runs
    Then ADK should use the `default` agent

  Scenario: Missing default agent fails implicit resolution
    Given a project does not contain `.adk/agents/default.ts`
    And a workflow calls `adk.skill(...)` without an explicit agent
    When the workflow runs
    Then ADK should fail with a clear missing-default-agent error
