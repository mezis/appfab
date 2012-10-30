Feature: Google OAuth2 sign-in/sign-up
  As a user
  In order to use the app
  I want to sign in or sign up with my Google ID


  Scenario: Sign in with Google ID
    Given I am not authenticated
      And I authorise the app with my Google account "John McFoo"
     When I sign in with Google
     Then I should see a success message

  Scenario: Refusing to authorise the app
    Given I am not authenticated
      And I do not authorise the app with my Google account
     When I sign in with Google
     Then I should see a failure message
