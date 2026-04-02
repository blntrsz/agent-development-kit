Feature: Do not provision agent secrets
  Scenario: Deploy does not create agent secrets
    Given agents reference remote secrets
    When the user runs `adk deploy remote`
    Then ADK should not prompt for those agent secrets
    And ADK should not create them automatically
