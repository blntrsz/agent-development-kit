# Remote Deploy

## Overview
The Remote Deploy slice defines how a repository is prepared for remote execution. It provisions the remote execution footprint once per repository, account, and region, and publishes the sandbox artifacts remote runs depend on.

## Boundaries
Included:
- `adk deploy remote` invocation and AWS profile selection
- Repository clone token prompt and storage
- Publishing sandbox images for remote execution
- Preconditions that remote runs depend on

Excluded:
- Workflow registration and runtime semantics
- Agent definition, except for the rule that agent secrets are not provisioned here
- Local execution behavior

## Main Concepts
The terms in this section are the ubiquitous language for the Remote Deploy slice.

| Concept | Definition | Relationship |
| --- | --- | --- |
| Remote deployment | Repository-scoped remote execution setup in an AWS account and region. | Required before `adk run --remote` can succeed. |
| AWS profile | CLI-selected AWS credential source. | Determines the target account and region for deployment. |
| Repository clone token | GitHub token used for fresh ECS clones. | Prompted during deploy and stored in Secrets Manager. |
| Published sandbox image | Remote-ready sandbox artifact. | Used by remote runs instead of local sandbox builds. |
| Remote run prerequisite | Condition that must exist before `adk run --remote`. | Satisfied by a successful remote deployment. |

## Business Rules
- `adk deploy remote` runs once per repository, AWS account, and AWS region.
- `--profile` selects the AWS credentials, account, and region.
- Deploy prompts for a GitHub token for fresh repository clones and stores it in AWS Secrets Manager.
- Deploy builds and publishes all sandboxes under `.adk/sandbox/`.
- Deploy does not prompt for or create agent secrets.
- `adk run --remote` must fail clearly when remote deployment has not happened yet.

## Features
- [Deploy remote with AWS profile](features/deploy-remote-with-aws-profile.feature)
- [Prompt for repository clone token](features/prompt-for-repository-clone-token.feature)
- [Publish all sandboxes](features/publish-all-sandboxes.feature)
- [Do not provision agent secrets](features/do-not-provision-agent-secrets.feature)
- [Require deploy before remote run](features/require-deploy-before-remote-run.feature)
