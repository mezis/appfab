Feature: Approving ideas
  As a benevolent dictator
  In order to make sure design and conception are excellent
  I want to approve ideas before they get implemented

  Background:
    Given a benevolent dictator named "Barnaby"
    And a designed idea "Solo, make it so"    

  Scenario: Discovering approvable ideas
    When I sign in as "Barnaby"
    Then the idea should be in angle "approvable"

  Scenario: Approving an idea
    When I sign in as "Barnaby"
    And I approve the idea
    Then the idea should be approved
    And the idea should be in angle "buildable"

  Scenario: No double approvals
    When I sign in as "Barnaby"
    And I approve the idea
    Then I cannot approve the idea
