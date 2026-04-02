Feature: Resolve a bare skill id
  Scenario: Bare id resolves to `SKILL.md`
    Given the checked-out project contains `.agents/skills/triage/SKILL.md`
    When a workflow calls `adk.skill("triage")`
    Then ADK should load `.agents/skills/triage/SKILL.md`
