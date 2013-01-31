Feature: Create teams
  As an account owner
  In order to manage my team
  I want to edit team settings

  Background:
    Given an account owner named "Anatole"
    And I sign in as "Anatole"

  Scenario: Edit team name
    When I change my account name to "Foobar"
    Then the account name is "Foobar"


  Scenario: Edit categories
    When I change my account categories to "foo, bar"
    Then the account categories are "foo, bar"
