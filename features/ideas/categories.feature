Feature: Grouping ideas by category
  As a product manager or an architect
  In order to give ideas more focus
  I want to give eachidea a category

  Background:
    Given a user named "Ursula"
    And I sign in as "Ursula" 

    Given a category "TV Show"
    And a category "Movie"
    And a submitted idea "Solo, make it so"

  Scenario: Filter by category
    When I set the idea category to "TV Show"
    Then the idea should be listed in category "TV Show"
    And the idea should be listed in category "All Categories"
    But the idea should not be listed in category "Movie"
