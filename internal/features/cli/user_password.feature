@user
Feature: Ernest user change-password

  Scenario: Non logged user password modification
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "user change-password"
    Then The output should contain "You don’t have permissions to perform this action"
    When I run ernest with "user change-password --user usr --password xx"
    Then The output should contain "You don’t have permissions to perform this action"

  Scenario: Plain user password modification
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "pwd"
    And The output should contain "Welcome back usr"
    When I run ernest with "user change-password --user usr --password xx"
    Then The output should contain "You don’t have permissions to perform this action"
    When I run ernest with "user change-password --current-password pwd --password newpwd"
    Then The output should contain "Your password has been changed"
    And I'm logged in as "usr" / "newpwd"
    Then The output should contain "Welcome back usr"
    When I run ernest with "user change-password --current-password newpwd --password pwd"
    Then The output should contain "Your password has been changed"
    And I'm logged in as "usr" / "pwd"
    Then The output should contain "Welcome back usr"

  Scenario: Admin self password modification
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "ci_admin" / "pwd"
    And The output should contain "Welcome back ci_admin"
    When I run ernest with "user change-password --current-password pwd --password newpwd"
    Then The output should contain "Your password has been changed"
    And I'm logged in as "ci_admin" / "newpwd"
    Then The output should contain "Welcome back ci_admin"
    When I run ernest with "user change-password --current-password newpwd --password pwd"
    Then The output should contain "Your password has been changed"
    And I'm logged in as "ci_admin" / "pwd"
    Then The output should contain "Welcome back ci_admin"

  Scenario: Admin self group password modification
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "ci_admin" / "pwd"
    And The output should contain "Welcome back ci_admin"
    When I run ernest with "user change-password --user usr --password newpwd"
    Then The output should contain "`usr` password has been changed"
    And I'm logged in as "usr" / "newpwd"
    Then The output should contain "Welcome back usr"
    When I run ernest with "user change-password --current-password newpwd --password pwd"
    Then The output should contain "Your password has been changed"




