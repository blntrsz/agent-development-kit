Feature: Deploy remote with an AWS profile
  Scenario: Deployment uses the selected AWS profile
    Given the user runs `adk deploy remote --profile my-profile`
    When ADK deploys remote infrastructure
    Then ADK should use AWS credentials, account, and region from `my-profile`

  Scenario: Only one deployment exists per repo per account and region
    Given a repository has already been deployed to an AWS account and region
    When the user deploys the same repository again to that same account and region
    Then ADK should target the same remote deployment
