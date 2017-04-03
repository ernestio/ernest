@user @user_create
Feature: Ernest user create

  Scenario: User creates a user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And the user "jane" does not exist
    When I run ernest with "user create jane secret"
    Then the output should contain "You're not allowed to perform this action, please contact your administrator."

  Scenario: Admin creates a user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
		And the user "john" does not exist
    When I run ernest with "user create john secret"
    Then the output should contain "User created"

  Scenario: Admin creates a duplicate user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
		And the user "john" exists
    When I run ernest with "user create john secret"
    Then the output should contain "Specified user already exists, please choose a different one."

  Scenario: Unuthenticated user creates a user
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "user create john secret"
    Then the output should contain "You're not allowed to perform this action, please log in."
