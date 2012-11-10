Feature: Sizing ideas
  As a product manager or an architect
  In order to manage the team bandwidth
  I want to give ideas a T-shirt size

  Background:
    Given a submitted idea "Solo, make it so"
    Given a product manager named "Peter"
    Given an architect named "Alphonse"
    Given a user named "Ursula"

  Scenario: Size an idea
    When I sign in as "Ursula"
    Then I cannot size the idea

    When I sign in as "Alphonse"
    And I design-size the idea as "L"

    When I sign in as "Peter"
    And I development-size the idea as "M"

    When I sign in as "Ursula"
    Then I see the idea is sized

