Feature: Voting for ideas
  As a user
  In order to make contribute to product priorisation
  I want to vote for ideas

  Background:
    Given a user named "Alphonse"
    Given a user named "Ulysse"
    And a vetted idea "Solo, make it so"
    # as an idea needs at least 2 votes:
    And "Alphonse" has backed the idea
    And I sign in as "Ulysse"
    

  Scenario: Discovering votable ideas
    Then the idea should be in angle "votable"

  Scenario: Voting for idea
    When I endorse the idea
    Then the idea should be endorsed
    And the idea should be in angle "votable"

  Scenario: Removing a vote
    When I endorse the idea
    And I cancel my endorse the idea
    
    Then the idea should be vetted
    And the idea should be in angle "votable"

  Scenario: The idea becomes pickable
    When I endorse the idea

    Given a product manager named "Patrick"
    And I sign in as "Patrick"
    Then the idea should be in angle "pickable"

  Scenario: No double votes
    When I endorse the idea
    Then I cannot endorse the idea

  Scenario: No double un-voting
    When I endorse the idea
    And I cancel my endorse the idea
    Then I cannot remove my endorsement for the idea




# Vetting given a sized idea can be created by an architect
# Vetting given a sized idea can only be done once by a PM
# Vetting given a sized idea cannot be created by other roles

# Vetting given a sized idea can be created by an architect
# Vetting given a sized idea can only be done once by a PM
# Vetting given a sized idea cannot be created by other roles