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

  Scenario: Setting daily digest to true
    When I set daily digest preference to "false"
    Then daily digest preference should be "Doesn't receive daily digest email"

  Scenario: Setting daily digest to false
    When I set daily digest preference to "true"
    Then daily digest preference should be "Receives daily digest email"
