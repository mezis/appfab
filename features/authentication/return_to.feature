Feature: Return to original URL after logging in
  As a user
  In order to be able to use email inks
  I want the app to redirect me after logging in

  Background: Establish the account
    Given an account "Foobars"
    Given I authorise the app with my Google account "John McFoo"
      And I sign in with Google
      And I create an account "Foobars"
      And I submit an idea "Hello World"
      And I am not authenticated

  Scenario: Sign in with Google ID
     When I visit the idea
      And I sign in with Google
     Then I should be on the idea page
