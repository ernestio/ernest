@role @role_list
Feature: Ernest role list

  Scenario: User lists rolls
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "role list"
    Then the output should contain "owner"
    And the output should contain "reader"

  Scenario: Unauthenticated user lists roles
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "role list"
    Then the output should contain "You're not allowed to perform this action, please log in"
