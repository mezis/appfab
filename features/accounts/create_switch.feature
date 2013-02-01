Feature: Create teams
  As a user
  In order to organise a product team
  I want to create teams

  Scenario: Create team on sign-up
    Given I am not authenticated
      And I authorise the app with my Google account "John McFoo"
     When I sign in with Google
     Then I should be prompted to create an account

  Scenario: Create additional team
    Given a user named "Ursula"
      And I sign in as "Ursula"
     When I create an account "Foo Fighters"
     Then the account name should be "Foo Fighters"

  Scenario: Switch teams
    Given a user named "Ursula"
      And I sign in as "Ursula"
      And the account name is "Foo Fighters"

     When I create an account "Ablabacabar"
     Then the account name should be "Ablabacabar"

     When I switch to the account "Foo Fighters"
     Then the account name should be "Foo Fighters"
