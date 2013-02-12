Feature: Act as user
  As an account owner
  In order to resolve issues my teammates have
  I want to act as others

  Background:
    Given a user named "Ulysse"
      And an account owner named "Anatole"
      And I sign in as "Anatole"
    
  Scenario: Act as user
     When I act as "Ulysse"
     Then I should be "Ulysse"
      And I should see a warning message
 
     When I act as myself
     Then I should be "Anatole"

  Scenario: Cannot recursively act as
    Given an account owner named "Alphone"
     When I act as "Alphone"
      And I act as "Ulysse"
     Then I should see an error message

  Scenario: Cannot switch accounts when acting as
    Given the account name is "Team Stuff"
    Given an account "My Side Projects"
      And "Ulysse" is a member of account "My Side Projects"

     When I act as "Ulysse"
      And I switch to the account "My Side Projects"
     Then I should see an error message
      And the account name should be "Team Stuff"
