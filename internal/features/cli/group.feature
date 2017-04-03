@group
Feature: Ernest group

  Scenario: running "group" command as logged in user
    Given I setup ernest with target "https://ernest.local"
    When I'm logged in as "usr" / "pwd"
    And I run ernest with "group"
    Then The output should contain "delete"
    And The output should contain "list"
    And The output should contain "create"
    And The output should contain "add-user"
    And The output should contain "remove-user"
    And The output should contain "add-datacenter"
    And The output should contain "remove-datacenter"

  Scenario: running "group" command as non logged in user
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "group"
    Then The output should contain "delete"
    And The output should contain "list"
    And The output should contain "create"
    And The output should contain "add-user"
    And The output should contain "remove-user"
    And The output should contain "add-datacenter"
    And The output should contain "remove-datacenter"

