Feature: Profile edition
  As a user
  In order to make myself visible
  I want to edit my profile

  Background:
    Given a user named "Ulysse"
    And I sign in as "Ulysse"
    
  Scenario: Changing name
    When I change my full name to "John Doe"
    Then my full name should be "John Doe"
