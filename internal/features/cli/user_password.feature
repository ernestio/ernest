@user
Feature: Ernest user change-password

  Background:
    Given I setup ernest with target "https://ernest.local"

  Scenario: Non logged user password modification
    Given I logout
    When I run ernest with "user change-password"
    Then The output should contain "You don’t have permissions to perform this action"
    When I run ernest with "user change-password --user usr --password xx"
    Then The output should contain "You don’t have permissions to perform this action"

  Scenario: Plain user password modification
    Given I'm logged in as "usr" / "secret123"
    And The output should contain "Welcome back usr"
    When I run ernest with "user change-password --user usr --password xx"
    Then The output should contain "You don’t have permissions to perform this action"
    When I run ernest with "user change-password --current-password secret123 --password newsecret"
    Then The output should contain "Your password has been changed"
    And I'm logged in as "usr" / "newsecret"
    Then The output should contain "Welcome back usr"
    When I run ernest with "user change-password --current-password newsecret --password secret123"
    Then The output should contain "Your password has been changed"
    And I'm logged in as "usr" / "secret123"
    Then The output should contain "Welcome back usr"

  Scenario: User updates their password with a password containing invalid characters
    Given I'm logged in as "usr" / "secret123"
    When I run ernest with "user change-password --current-password secret123 --password secret^123"
    Then The output should contain "Password can only contain the following characters: a-z 0-9 @._-"

  Scenario: User updates their password with a password less than the minimum length
    Given I'm logged in as "usr" / "secret123"
    When I run ernest with "user change-password --current-password secret123 --password secret"
    Then The output should contain "Minimum password length is 8 characters"

  Scenario: Admin self password modification
    Given I'm logged in as "ci_admin" / "secret123"
    And The output should contain "Welcome back ci_admin"
    When I run ernest with "user change-password --current-password secret123 --password newsecret"
    Then The output should contain "Your password has been changed"
    And I'm logged in as "ci_admin" / "newsecret"
    Then The output should contain "Welcome back ci_admin"
    When I run ernest with "user change-password --current-password newsecret --password secret123"
    Then The output should contain "Your password has been changed"
    And I'm logged in as "ci_admin" / "secret123"
    Then The output should contain "Welcome back ci_admin"

  Scenario: Admin self group password modification
    Given I'm logged in as "ci_admin" / "secret123"
    And The output should contain "Welcome back ci_admin"
    When I run ernest with "user change-password --user usr --password newsecret"
    Then The output should contain "`usr` password has been changed"
    And I'm logged in as "usr" / "newsecret"
    Then The output should contain "Welcome back usr"
    When I run ernest with "user change-password --current-password newsecret --password secret123"
    Then The output should contain "Your password has been changed"
