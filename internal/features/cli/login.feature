@login
Feature: Ernest login

  Background: 
    Given I setup ernest with target "https://ernest.local"

  Scenario: Login as admin user
    When I'm logged in as "ci_admin" / "secret123"
    Then The output should contain "Welcome back ci_admin"

  Scenario: Login as plain user
    When I'm logged in as "usr" / "secret123"
    Then The output should contain "Welcome back usr"

  Scenario: Login with non existing user
    When I'm logged in as "unexisting" / "secret123"
    Then The output should contain "The keypair user / password does not match any user on the database, please try again"

  Scenario: Login with no username
    When I'm logged in as "" / "invalid123"
    Then The output should contain "Username cannot be empty"

  Scenario: Login with invalid characters in username
    When I'm logged in as "usr^" / "secret123"
    Then The output should contain "Username can only contain the following characters: a-z 0-9 @._-"

  Scenario: Login with no username
    When I'm logged in as "" / "invalid123"
    Then The output should contain "Username cannot be empty"

  Scenario: Login with no password
    When I'm logged in as "usr" / ""
    Then The output should contain "Password cannot be empty"

  Scenario: Login with invalid characters in password
    When I'm logged in as "usr" / "secret^123"
    Then The output should contain "Password can only contain the following characters: a-z 0-9 @._-"
