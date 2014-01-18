Feature: Idea search
  As a user
  In order to find existing ideas
  I want to be able to search all ideas

  Background:
    Given a submitted idea "A good idea for the future"
    Given a submitted idea "Idea about something else"
    Given a user named "Ursula"
    And I sign in as "Ursula"

  Scenario: Query contains one result
    When I search for "future"
    Then I should see "A good idea for the future"
    And I should not see "Idea about something else"
