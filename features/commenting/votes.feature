Feature: Comments
  As a user
  In order improve relevance of an idea discussion
  I want to rate comments

  Background:
    Given a user named "Ulysse"
    And a user named "Alphonse"

    And a submitted idea "Let's have a pub night out"
    And a comment "Yay, I felt kinda thirsty today" by "Alphonse"

    And "Ulysse" has 10 karma
    And "Alphonse" has 10 karma

    And I sign in as "Ulysse"

  Scenario: Upvoting new comment
    When I upvote the comment
    Then the comment should be upvoted
    And I should have 11 karma
    And "Alphonse" should have 12 karma

  Scenario: Downvoting a comment
    When I downvote the comment
    Then the comment should be downvoted
    And I should have 9 karma
    And "Alphonse" should have 0 karma

  # Only possible within 15 minutes
  # Scenario: Editing comment

  # Scenario: Responding to a comment

  # it 'is editable for 15 minutes'
  # it 'is deletable for 15 minutes'
  # it 'notifies parent author when deleted'
  # it 'is not deletable if it has children'
