Feature: Developer sign-in/sign-up
  As a developer
  In order to play around the app
  I want to sign in or sign up with test credentials


  Scenario: Sign up as a developer
    Given I am not authenticated
     When I sign in as the developer "John McFoo"
     Then I should see a success message
