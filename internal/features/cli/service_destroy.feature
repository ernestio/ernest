@environment @environment_destroy
Feature: Environment destroy

  Scenario: Non logged environment destroy
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "env destroy"
    Then The output should contain "Please provide required parameters:"
    Then The output should contain "$ ernest env delete <my_project> <my_environment>"
    When I run ernest with "env destroy fakeaws destroyable"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged environment destroy unexisting
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The environment "fakeaws/unexisting" does not exist
    When I run ernest with "env destroy"
    Then The output should contain "Please provide required parameters:"
    Then The output should contain "$ ernest env delete <my_project> <my_environment>"
    When I run ernest with "env destroy fakeaws"
    Then The output should contain "Please provide required parameters:"
    Then The output should contain "$ ernest env delete <my_project> <my_environment>"
    When I run ernest with "env destroy fakeaws unexisting --yes"
    Then The output should contain "Environment not found"

  Scenario: Logged environment destroy
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The environment "fakeaws/destroyable" does not exist
    And I apply the definition "destroyable.yml"
    And I wait for "5" seconds
    When I run ernest with "env destroy fakeaws destroyable --yes"
    Then The output should contain "Environment Name:"
    Then The output should contain "Destroyed"
    And The output should contain "Environment successfully removed"
    And I wait for "1" seconds
    When I run ernest with "env destroy fakeaws destroyable --yes"
    Then The output should contain "Environment not found"
