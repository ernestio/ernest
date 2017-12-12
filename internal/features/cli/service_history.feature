@environment @environment_history
Feature: Environment history

  Scenario: Non logged environment history
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "env history"
    Then The output should contain "Please provide required parameters:"
    And The output should contain "$ ernest env history <my_project> <my_env>"
    When I run ernest with "env destroy fakeaws destroyable"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged environment history unexisting
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "env history"
    Then The output should contain "Please provide required parameters:"
    And The output should contain "$ ernest env history <my_project> <my_env>"
    When I run ernest with "env history fakeaws"
    Then The output should contain "Please provide required parameters:"
    And The output should contain "$ ernest env history <my_project> <my_env>"
    When I run ernest with "env history fakeaws unexisting"
    Then The output should contain "Environment not found"

  Scenario: Logged environment history
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The environment "fakeaws/destroyable" does not exist
    And I apply the definition "destroyable.yml"
    And I wait for "5" seconds
    And I apply the definition "destroyable2.yml"
    And I wait for "5" seconds
    When I run ernest with "env history fakeaws destroyable"
    Then The output line number "3" should contain "destroyable"
    And The output line number "3" should contain "done"
    And The output line number "3" should contain "usr"
    And The output line number "4" should contain "destroyable"
    And The output line number "4" should contain "usr"
    And The output line number "4" should contain "done"
