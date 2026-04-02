Feature: Build a local sandbox on first use
  Scenario: Missing local sandbox image is built automatically
    Given the user starts a local run
    And the selected sandbox image does not exist locally
    When ADK starts the run
    Then ADK should build the sandbox image automatically
