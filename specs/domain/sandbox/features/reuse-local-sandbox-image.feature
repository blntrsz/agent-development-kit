Feature: Reuse a local sandbox image
  Scenario: Existing local sandbox image is reused
    Given the selected sandbox image already exists locally
    When ADK starts another local run
    Then ADK should reuse that image

  Scenario: Local sandbox image cache key is project-scoped
    Given two different project roots use a sandbox named `default`
    When ADK computes the local image cache key
    Then the key should include the absolute project root and the sandbox name
