@user @user_info
Feature: Ernest user info

  Scenario: User lists information about themselves
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "user info"
    Then the output should contain "john"

  Scenario: User lists information about another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the user "jane" exists
    When I run ernest with "user info --user jane"
    Then the output should contain "You're not allowed to perform this action, please contact your administrator."

  Scenario: Admin lists information about themselves
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    When I run ernest with "user info"
    Then the output should contain "admin"
    And the output should contain "Admin: True"

  Scenario: Admin lists information about another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    And the user "john" exists
    When I run ernest with "user info --user john"
    Then the output should contain "john"
      
  Scenario: Admin lists information about another admin user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
		And the user "admin2" exists with admin role
    When I run ernest with "user info --user admin2"
    Then the output should contain "admin2"
    And the output should contain "Admin: True"

  Scenario: Unauthenticated user lists information about themselves
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "user info"
    Then the output should contain "You're not allowed to perform this action, please log in."
