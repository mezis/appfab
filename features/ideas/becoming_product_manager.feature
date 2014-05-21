Feature: Becoming product manager
  As a product manager
  I want to become a product manager on an idea

  Background:
    Given a product manager named "Peter"
    And a submitter named "Leia"
    And a sized idea "Solo, make it so"

  Scenario: Becoming a product manager
    When I sign in as "Peter"
    And I choose to become the product manager
    Then "Peter" should be the product manager
