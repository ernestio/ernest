@user
Feature: Ernest user

  Scenario: running user command as logged in user
    Given I setup ernest with target "https://ernest.local"
    When I'm logged in as "usr" / "pwd"
    And I run ernest with "user"
    Then The output should contain "list"
    And The output should contain "create"
    And The output should contain "change-password"
    And The output should contain "disable"

  Scenario: running user command as non logged in user
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "user"
    Then The output should contain "list"
    And The output should contain "create"
    And The output should contain "change-password"
    And The output should contain "disable"
