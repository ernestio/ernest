@user
Feature: Ernest user list

  Background:
    Given I setup ernest with target "https://ernest.local"

  Scenario: Non logged user creation
    Given I logout
    When I run ernest with "user create"
    Then The output should contain "You should specify an user username and a password"
    When I run ernest with "user create user"
    Then The output should contain "You should specify the user password"
    When I run ernest with "user create test_creation secret123"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Plain user creation
    When I'm logged in as "usr" / "secret123"
    And I run ernest with "user create test_creation secret123"
    Then The output should contain "You're not allowed to perform this action, please contact your admin"

  Scenario: Admin user creation
    Given the user "test_creation" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "user create test_creation secret123"
    Then The output should contain "User test_creation successfully created"

  Scenario: Admin user creation with no username
    Given the user "test_creation" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "user create"
    Then The output should contain "You should specify an user username and a password"

  Scenario: Admin user creation with no password
    Given the user "test_creation" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "user create test_creation"
    Then The output should contain "You should specify the user password"

  Scenario: Admin user creation with a username containing invalid characters
    Given the user "test^creation" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "user create test^creation secret123"
    Then The output should contain "Username can only contain the following characters: a-z 0-9 @._-"

  Scenario: Admin user creation with a password less than the minimum length
    Given the user "test_creation" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "user create test_creation secret"
    Then The output should contain "Minimum password length is 8 characters"

  Scenario: Admin user creation with a password containing invalid characters
    Given the user "test_creation" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "user create test_creation secret^123"
    Then The output should contain "Password can only contain the following characters: a-z 0-9 @._-"

  Scenario: Admin user creation with no username
    Given the user "test_creation" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "user create"
    Then The output should contain "You should specify an user username and a password"

  Scenario: Admin user creation with no password
    Given the user "test_creation" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "user create test_creation"
    Then The output should contain "You should specify the user password"

  Scenario: Admin user creation with a username containing invalid characters
    Given the user "test^creation" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "user create test^creation secret123"
    Then The output should contain "Username can only contain the following characters: a-z 0-9 @._-"

  Scenario: Admin user creation with a password less than the minimum length
    Given the user "test_creation" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "user create test_creation secret"
    Then The output should contain "Minimum password length is 8 characters"

  Scenario: Admin user creation with a password containing invalid characters
    Given the user "test_creation" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "user create test_creation secret^123"
    Then The output should contain "Password can only contain the following characters: a-z 0-9 @._-"

  Scenario: Duplicated user creation
    When I'm logged in as "ci_admin" / "secret123"
    And I run ernest with "user create duplicated secret123"
    And I run ernest with "user create duplicated secret123"
    Then The output should contain "Specified user already exists"
