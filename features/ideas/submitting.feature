Feature: Sumitting ideas
  As a user
  In order to propose product changes
  I want to submit new ideas

  Background:
    Given a submitter named "Ursula"
      And I sign in as "Ursula"

  Scenario: Normal submission
     When I submit an idea "My brilliant idea"
     Then the idea should be submitted
      And the idea should be in angle "discussable"
      And the idea should be in angle "followed"
