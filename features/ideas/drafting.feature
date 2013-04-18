Feature: Drafting ideas
  As a user
  In order to prepare my ideas for submission
  I want save ideas as drafts

  Background:
    Given a user named "Ursula"
      And I sign in as "Ursula"

  @javascript
  Scenario: Create as draft
     When I submit a draft "This could become great"
     Then the idea should be draft
      And the idea should be in angle "followed"
      But the idea should not be in angle "discussable"

  @javascript
  Scenario: Edit a draft
     When I submit a draft "This could become great"
      And I change the draft title to "Even better this way"
     Then the idea title should be "Even better this way"

  @javascript
  Scenario: Publish idea
     When I submit a draft "This could become great"
      And I publish the draft
     Then the idea should be submitted
