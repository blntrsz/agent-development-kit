Feature: Run a skill with an agent
  Scenario: Skill arguments are passed through options
    Given a workflow calls `adk.skill("triage", { args: { issue: 123 } })`
    When ADK runs the skill
    Then ADK should pass the skill arguments to the skill

  Scenario: Structured skill output is validated
    Given a workflow calls `adk.skill("triage", { result: schema })`
    When ADK runs the skill
    Then ADK should validate the structured result against the schema

  Scenario: Default agent is used when no explicit agent is given
    Given a workflow calls `adk.skill("triage")`
    When ADK runs the skill
    Then ADK should use the default agent
