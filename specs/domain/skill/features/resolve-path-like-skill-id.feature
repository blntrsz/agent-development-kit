Feature: Resolve a path-like skill id
  Scenario: Path-like id resolves within `.agents/skills`
    Given the checked-out project contains `.agents/skills/review/analyze.md`
    When a workflow calls `adk.skill("review/analyze.md")`
    Then ADK should load `.agents/skills/review/analyze.md`
