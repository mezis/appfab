Feature: User roles
  As an account owner
  In order to make sure my users are efficient
  I want to assign the roles

  Background:
    Given an account owner named "Alexander"
    And a user named "Ulysse"
    And I sign in as "Alexander"
    
  Scenario: Adding a roles
    When I give the "product manager" role to "Ulysse"
    And I give the "developer" role to "Ulysse"
    Then "Ulysse" should be a product manager
    And "Ulysse" should be a developer
    
  Scenario: Removing roles
    When I give the "product manager" role to "Ulysse"
    And I remove the "product manager" role from "Ulysse"
    Then "Ulysse" should not be a product manager
  