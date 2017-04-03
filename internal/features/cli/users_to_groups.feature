@group @users_to_groups
Feature: Ernest users to groups

  Scenario: Non logged - user to group
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "group add-user"
    Then The output should contain "You should specify the username and group name"
    When I run ernest with "group add-user tmp_user"
    Then The output should contain "You should specify the group name"
    When I run ernest with "group add-user tmp_user tmp_group"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Plain user - user to group
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "pwd"
    When I run ernest with "group add-user"
    Then The output should contain "You should specify the username and group name"
    When I run ernest with "group add-user tmp_user"
    Then The output should contain "You should specify the group name"
    When I run ernest with "group add-user tmp_user tmp_group"
    Then The output should contain "You don't have permissions to perform this action"

  Scenario: Admin user - user to group
    Given I setup ernest with target "https://ernest.local"
    And the group "tmp_group" exists
    And the user "tmp_user" exists
    And I'm logged in as "ci_admin" / "pwd"
    When I run ernest with "group add-user"
    Then The output should contain "You should specify the username and group name"
    When I run ernest with "group add-user tmp_user"
    Then The output should contain "You should specify the group name"
    When I run ernest with "group add-user tmp_user tmp_group"
    Then The output should contain "User 'tmp_user' is now assigned to group 'tmp_group'"
    When I run ernest with "user list"
    Then The output users table should contain "tmp_user" assigned to "tmp_group" group

  Scenario: Already assigned user
    Given I setup ernest with target "https://ernest.local"
    And the group "tmp_group" exists
    And the user "tmp_user" exists
    And I'm logged in as "ci_admin" / "pwd"
    And I run ernest with "group add-user tmp_user tmp_group"
    When I run ernest with "group add-user tmp_user tmp_group"
    Then The output should contain "User 'tmp_user' already belongs to 'tmp_group' group"

  Scenario: Unexisting group
    Given I setup ernest with target "https://ernest.local"
    And the group "tmp_group" does not exist
    And the user "tmp_user" exists
    And I'm logged in as "ci_admin" / "pwd"
    When I run ernest with "group add-user tmp_user tmp_group"
    Then The output should contain "Group 'tmp_group' does not exist"

  Scenario: Unexisting user
    Given I setup ernest with target "https://ernest.local"
    And the user "tmp_user" does not exist
    And the group "tmp_group" exists
    And I'm logged in as "ci_admin" / "pwd"
    When I run ernest with "group add-user tmp_user tmp_group"
    Then The output should contain "User 'tmp_user' does not exist"

  Scenario: Admin user - remove user from  group
    Given I setup ernest with target "https://ernest.local"
    And the group "tmp_group" exists
    And the user "tmp_user" exists
    And I'm logged in as "ci_admin" / "pwd"
    And I run ernest with "group add-user tmp_user tmp_group"
    When I run ernest with "group remove-user"
    Then The output should contain "You should specify the username and group name"
    When I run ernest with "group remove-user tmp_user"
    Then The output should contain "You should specify the group name"
    When I run ernest with "group remove-user tmp_user tmp_group"
    Then The output should contain "User 'tmp_user' is not assigned anymore to group 'tmp_group'"
    When I run ernest with "user list"
    Then The output users table should contain "tmp_user" assigned to " " group
