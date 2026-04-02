# Skill

## Overview
The Skill slice defines how workflow skills are resolved from `.agents/skills/`. It gives ADK a strict local lookup model for both named skills and path-like skill ids.

## Boundaries
Included:
- Skill lookup from the checked-out project
- Bare skill id resolution
- Path-like skill id resolution
- Protection against escaping the skill root

Excluded:
- Agent selection during skill execution
- Workflow orchestration
- Built-in, remote, or marketplace skill resolution

## Main Concepts
The terms in this section are the ubiquitous language for the Skill slice.

| Concept | Definition | Relationship |
| --- | --- | --- |
| Skill | Reusable prompt artifact stored under `.agents/skills/`. | Executed through `adk.skill(...)`. |
| Bare skill id | Short identifier like `triage`. | Resolves to `<skill>/SKILL.md`. |
| Path-like skill id | Relative path like `review/analyze.md`. | Resolves within the skill root without changing the root boundary. |
| Skill root | Directory `.agents/skills/` in the checked-out project. | Defines the allowed resolution boundary for all skills. |

## Business Rules
- Skill resolution is local to the checked-out project root.
- Bare ids resolve to `.agents/skills/<name>/SKILL.md`.
- Path-like ids resolve within `.agents/skills/`.
- Resolution must not escape the skill root.
- Missing, built-in, and remote skill resolution are outside v1.

## Features
- [Resolve bare skill id](features/resolve-bare-skill-id.feature)
- [Resolve path-like skill id](features/resolve-path-like-skill-id.feature)
- [Reject skills outside the skill root](features/reject-skills-outside-the-skill-root.feature)
