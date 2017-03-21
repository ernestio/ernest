@login
Feature: Ernest login

  Scenario: Login as admin user
    Given I setup ernest with target "https://ernest.local"
    When I'm logged in as "ci_admin" / "pwd"
    Then The output should contain "Welcome back ci_admin"

  Scenario: Login as plain user
    Given I setup ernest with target "https://ernest.local"
    When I'm logged in as "usr" / "pwd"
    Then The output should contain "Welcome back usr"

  Scenario: Login with non existing user
    Given I setup ernest with target "https://ernest.local"
    When I'm logged in as "unexisting" / "pwd"
    Then The output should contain "The keypair user / password does not match any user on the database, please try again"

  Scenario: Login with invalid password
    Given I setup ernest with target "https://ernest.local"
    When I'm logged in as "usr" / "invalid"
    Then The output should contain "The keypair user / password does not match any user on the database, please try again"
