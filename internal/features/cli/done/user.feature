@user
Feature: Ernest user

  Scenario: User calls user subcommand
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "user"
    Then the output should contain "list"
    And the output should contain "info"
    And the output should contain "create"
    And the output should contain "update"
    And the output should contain "delete"

  Scenario: Unauthenticated user calls user subcommand
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "user"
    Then the output should contain "list"
    And the output should contain "info"
    And the output should contain "create"
    And the output should contain "update"
    And the output should contain "delete"
