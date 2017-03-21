@user
Feature: Ernest user list

  Scenario: Non logged user listing
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "user list"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged user listing
    Given I setup ernest with target "https://ernest.local"
    When I'm logged in as "usr" / "pwd"
    And I run ernest with "user list"
    Then The output should contain "usr"
    And The output should not contain "ci_admin"

  Scenario: Admin user listing
    Given I setup ernest with target "https://ernest.local"
    When I'm logged in as "ci_admin" / "pwd"
    And I run ernest with "user list"
    Then The output should contain "usr"
    And The output should contain "ci_admin"


