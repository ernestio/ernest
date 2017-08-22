@user
Feature: Ernest user disable

  Scenario: Non logged user disable
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "user disable"
    Then The output should contain "You should specify an username"
    When I run ernest with "user disable usr"
    Then The output should contain "You don’t have permissions to perform this action"

  Scenario: Plain user disable
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The output should contain "Welcome back usr"
    When I run ernest with "user disable"
    Then The output should contain "You should specify an username"
    When I run ernest with "user disable usr"
    Then The output should contain "You don’t have permissions to perform this action"

  Scenario: Admin user disable
    Given I setup ernest with target "https://ernest.local"
    And the user "to_disable" does not exist
    And I'm logged in as "ci_admin" / "secret123"
    And The output should contain "Welcome back ci_admin"
    When I run ernest with "user create to_disable secret123"
    And I'm logged in as "to_disable" / "secret123"
    Then The output should contain "Welcome back to_disable"
    When I'm logged in as "ci_admin" / "secret123"
    And The output should contain "Welcome back ci_admin"
    And I run ernest with "user disable to_disable"
    And The output should contain "Account `to_disable` has been disabled"
    And I'm logged in as "to_disable" / "secret123"
    Then The output should contain "The keypair user / password does not match any user on the database, please try again"

