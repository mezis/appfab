Feature: Comments
  As a user
  In order to contribute to an idea
  I want to discuss it with other users

  Background:
    Given a user named "Ulysse"
    And a submitted idea "Let's have a pub night out"
    And I sign in as "Ulysse"

  Scenario: Adding a new comment
    When I comment with "Nay, gotta feed the cats"
    Then I can delete the comment

  Scenario: Delete a comment
    When I comment with "Nay, gotta feed the cats"
    And I delete the comment
    Then the idea should have no comments

  # Only possible within 15 minutes
  # Scenario: Editing comment

  # Scenario: Responding to a comment

  # it 'is editable for 15 minutes'
  # it 'is deletable for 15 minutes'
  # it 'notifies parent author when deleted'
  # it 'is not deletable if it has children'
