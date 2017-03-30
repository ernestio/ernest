@user @user_update
Feature: Ernest user update

  Scenario: User updates their own password
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "user update password john newsecret"
    Then the output should contain "Password changed"

  Scenario: User updates another users password
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "user update password jane secret"
    Then the output should contain "You're not allowed to perform this action, please contact your administrator."

  Scenario: Admin updates another users password
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    And the user "john" exists
    When I run ernest with "user update password john secret"
    Then the output should contain "Password changed"

  Scenario: Unuthenticated user updates a user password
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "user update password john secret"
    Then the output should contain "You're not allowed to perform this action, please log in."
