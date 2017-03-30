@user @user_list
Feature: Ernest user list

  Scenario: User lists users
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the admin user "admin" exists
    When I run ernest with "user list"
    Then the output should contain "john"
    And the output should contain "admin"

  Scenario: Unauthenticated user lists users
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "user list"
    Then the output should contain "You're not allowed to perform this action, please log in."
