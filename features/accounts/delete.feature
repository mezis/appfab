Feature: Delete teams
  As a user
  In order to terminate a product
  I want to delete teams

  Scenario: Delete team
    Given an account owner named "Ursula"
     And I sign in as "Ursula"
     And the account name is "Foo One"

    When I create an account "Bar Two"
    Then the account name should be "Bar Two"

    When I delete the account
    Then the account name should be "Foo One"
  