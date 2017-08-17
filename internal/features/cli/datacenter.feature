@project
Feature: Ernest project

  Scenario: running "project" command as logged in user
    Given I setup ernest with target "https://ernest.local"
    When I'm logged in as "usr" / "secret123"
    And I run ernest with "project"
    And The output should contain "list"
    And The output should contain "create"

  Scenario: running "project" command as non logged in user
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "project"
    And The output should contain "list"
    And The output should contain "create"

