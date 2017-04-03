@group @group_create
Feature: Ernest group create

  Scenario: Non logged group creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "group create"
    Then The output should contain "You should specify the group name"
    When I run ernest with "group create tmp_group"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Plain user group creation
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "pwd"
    When I run ernest with "group create"
    Then The output should contain "You should specify the group name"
    When I run ernest with "group create tmp_group"
    Then The output should contain "You don't have permissions to perform this action"

  Scenario: Admin user group creation
    Given I setup ernest with target "https://ernest.local"
    And the group "tmp_group" does not exist
    And I'm logged in as "ci_admin" / "pwd"
    When I run ernest with "group create"
    Then The output should contain "You should specify the group name"
    When I run ernest with "group create tmp_group"
    Then The output should contain "Group 'tmp_group' successfully created, you can add users with 'ernest group add-user username tmp_group'"

  Scenario: Adding an already existing group
    Given I setup ernest with target "https://ernest.local"
    And the group "tmp_group" does not exist
    And I'm logged in as "ci_admin" / "pwd"
    And I run ernest with "group create tmp_group"
    When I run ernest with "group create tmp_group"
    Then The output should contain "Group 'tmp_group' already exists, please specify a different group name"


