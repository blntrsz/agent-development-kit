Feature: Prompt for repository clone token
  Scenario: Deploy prompts for a GitHub token
    Given the repository has an `origin` remote
    When the user runs `adk deploy remote --profile my-profile`
    Then ADK should prompt for a GitHub token for remote repository clones

  Scenario: Token is stored in Secrets Manager
    Given the user provides a GitHub token during deploy
    When ADK stores remote clone credentials
    Then ADK should store the token in AWS Secrets Manager
