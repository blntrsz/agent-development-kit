Feature: Reject skills outside the skill root
  Scenario: Escaping the skill root is not allowed
    Given a workflow calls `adk.skill("../secret.md")`
    When ADK resolves the skill path
    Then ADK should fail
    And ADK should not load files outside `.agents/skills/`
