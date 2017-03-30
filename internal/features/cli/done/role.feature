@role
Feature: Ernest role

  Scenario: User calls role subcommand
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "role"
    Then the output should contain "set"
    And the output should contain "unset"

  Scenario: Unauthenticated user calls role subcommand
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "role"
    Then the output should contain "set"
    And the output should contain "unset"
