@user @user_delete
Feature: Ernest user delete

  Scenario: User deletes a user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "user delete jane"
    Then the output should contain "You're not allowed to perform this action, please contact your administrator."

  Scenario: Admin deletes a user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    And the user "john" exists
    When I run ernest with "user delete john"
    Then the output should contain "User deleted"

  Scenario: Admin deletes a non existant user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    When I run ernest with "user delete john"
    Then the output should contain "User does not exist"

  Scenario: Admin deletes themselves
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    When I run ernest with "user delete admin"
    Then the output should contain "Currently logged in as admin, you cannot delete yourself."

  Scenario: Unuthenticated user deletes a user
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "user delete john"
    Then the output should contain "You're not allowed to perform this action, please log in."
