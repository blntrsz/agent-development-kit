Feature: Publish all sandboxes
  Scenario: Deploy publishes every sandbox
    Given the project contains multiple sandboxes under `.adk/sandbox/`
    When the user runs `adk deploy remote`
    Then ADK should build and publish all of them

  Scenario: Remote runs use deployed sandbox images
    Given remote sandbox images have been published
    When the user runs `adk run triage --remote`
    Then ADK should launch the run from the deployed sandbox image
