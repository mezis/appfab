Feature: Editing ideas
  As a user
  In order to react to comments on ideas
  I want to edit my ideas

  Background:
    Given a user named "Ursula"
      And I sign in as "Ursula"
      And a submitted idea "Put your boots on!"

  Scenario: Edit title
     When I change the idea title to "More clueful title"
     Then the idea title should be "More clueful title"

  Scenario: Category should not be reset
    Given a category "apples"
      And a category "oranges"
      And the idea category is "oranges"
     When I change the idea title to "More clueful title"
     Then the idea category should be "oranges"

