Feature: Vetting ideas
  As a product manager
  In order to make sure only valid idea get voted on
  I want to vet ideas

  Background:
    Given a product manager named "Peter"
    And an architect named "Archie"
    And a submitter named "Yoda"
    And a sized idea "Solo, make it so"
    And "Archie" has vetted the idea

  Scenario: Vetting an idea
    When I sign in as "Peter"
    And I vet the idea
    Then the idea should be vetted

  Scenario: Removing a vetting
    When I sign in as "Archie"
    And I unvet the idea

    And I sign in as "Peter"
    And I vet the idea
    Then the idea should be submitted

  Scenario: No removing the second vetting
    When I sign in as "Peter"
    When I vet the idea
    Then I cannot unvet the idea
    And the idea should be vetted

  Scenario: No double vetting
    When I sign in as "Archie"
    Then I cannot vet the idea

  Scenario: Should not be able to vet idea if I submitted it
    Given I sign in as "Peter"
    And I am also a submitter
    And I submit an idea "A flying car"
    Then the idea should be submitted
    And I cannot vet the idea



# Vetting given a sized idea can be created by an architect
# Vetting given a sized idea can only be done once by a PM
# Vetting given a sized idea cannot be created by other roles

# Vetting given a sized idea can be created by an architect
# Vetting given a sized idea can only be done once by a PM
# Vetting given a sized idea cannot be created by other roles
# Vetting given a sized idea cannot be vetted by the submitter