Feature: Stop sandbox
  Scenario: Selected sandbox stops after execution finishes
    Given a run started the `triage` sandbox
    When the run finishes
    Then ADK should stop the `triage` sandbox

  Scenario: Default sandbox stops after execution finishes
    Given a run started the default sandbox
    When the run finishes
    Then ADK should stop the default sandbox
