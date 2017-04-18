@user
Feature: Ernest user list

  Scenario: Non logged user creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "user create"
    Then The output should contain "You should specify an user username and a password"
    When I run ernest with "user create user"
    Then The output should contain "You should specify the user password"
    When I run ernest with "user create test_creation secret123"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Plain user creation
    Given I setup ernest with target "https://ernest.local"
    When I'm logged in as "usr" / "secret123"
    And I run ernest with "user create test_creation secret123"
    Then The output should contain "You're not allowed to perform this action, please contact your admin"

  Scenario: Admin user creation
    Given I setup ernest with target "https://ernest.local"
    And the user "test_creation" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "user create test_creation secret123"
    Then The output should contain "User test_creation successfully created"

  Scenario: Duplicated user creation
    Given I setup ernest with target "https://ernest.local"
    When I'm logged in as "ci_admin" / "secret123"
    And I run ernest with "user create duplicated secret123"
    And I run ernest with "user create duplicated secret123"
    Then The output should contain "Specified username already existis please choose a different one"


