@environment @environment_definition
Feature: Ernest environment definition

  Scenario: Non logged user definition
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "env definition"
    Then The output should contain "Please provide required parameters:"
    Then The output should contain "$ ernest env definition <my_project> <my_env>"
    When I run ernest with "env definition project environment"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged user definition
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The environment "fakeaws/destroyable" does not exist
    And I apply the definition "destroyable.yml"
    When I run ernest with "env definition"
    Then The output should contain "Please provide required parameters:"
    Then The output should contain "$ ernest env definition <my_project> <my_env>"
    When I run ernest with "env definition fakeaws"
    Then The output should contain "Please provide required parameters:"
    Then The output should contain "$ ernest env definition <my_project> <my_env>"
    When I run ernest with "env definition fakeaws destroyable"
    Then The output should contain "name: destroyable"
    And The output should contain "project: fakeaws"

  Scenario: Logged user definition for a specific build
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The environment "fakeaws/destroyable" does not exist
    And I apply the definition "destroyable.yml"
    When I run ernest with "env definition fakeaws destroyable"
    Then The output should contain "name: destroyable"
    And The output should contain "project: fakeaws"

  Scenario: Getting definitions by build id
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The environment "fakeaws/destroyable" does not exist
    And I apply the definition "definition_steps_1.yml"
    Then The output should contain "Platform Details"
    And I apply the definition "definition_steps_2.yml"
    Then The output should contain "Platform Details"
    And I apply the definition "definition_steps_3.yml"
    Then The output should contain "Platform Details"
    And I apply the definition "definition_steps_4.yml"
    Then The output should contain "Platform Details"
    When I run ernest with "env history fakeaws definition_steps"
    Then The output should contain "1 |"
    And The output should contain "2 |"
    And The output should contain "3 |"
    And The output should contain "4 |"
    When I run ernest with "env definition fakeaws definition_steps"
    Then The output should contain "count: 4"
    When I run ernest with "env definition fakeaws definition_steps --build 4"
    Then The output should contain "count: 4"
    When I run ernest with "env definition fakeaws definition_steps --build 3"
    Then The output should contain "count: 3"
    When I run ernest with "env definition fakeaws definition_steps --build 2"
    Then The output should contain "count: 2"
    When I run ernest with "env definition fakeaws definition_steps --build 1"
    Then The output should contain "count: 1"
