@environment @environment_list
Feature: Ernest environment list

  Scenario: Non logged user listing
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "environment list"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged user listing
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The environment "destroyable" does not exist
    And I apply the definition "destroyable.yml"
    When I run ernest with "environment list"
    Then The output should contain "destroyable"
    And The output should not contain "errored"

