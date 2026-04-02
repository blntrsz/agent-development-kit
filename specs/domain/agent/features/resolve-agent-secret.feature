Feature: Resolve an agent secret
  Scenario: Local mode resolves a string secret from the environment
    Given an agent declares `secret: "GITHUB_TOKEN"`
    And the local environment contains `GITHUB_TOKEN`
    When the agent runs in local mode
    Then ADK should provide the secret from the local environment

  Scenario: Remote mode resolves a string secret from Secrets Manager
    Given an agent declares `secret: "GITHUB_TOKEN"`
    And AWS Secrets Manager contains a secret named `GITHUB_TOKEN`
    When the agent runs in remote mode
    Then ADK should provide the secret from AWS Secrets Manager

  Scenario: ADK does not create missing remote agent secrets
    Given an agent declares a remote secret reference
    And AWS Secrets Manager does not contain that secret
    When the agent runs in remote mode
    Then ADK should fail
    And ADK should not create the secret automatically
