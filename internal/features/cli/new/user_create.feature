@user @user_create
Feature: Ernest user create

	Background:
    Given I setup ernest with target "https://ernest.local"

  Scenario: User creates a user
    Given I'm logged in as "john" / "secret"
		And the user "jane" does not exist
    When I run ernest with "user create jane secret"
    Then the output should contain "You're not allowed to perform this action, please contact your administrator."

  Scenario: Admin creates a user
    Given I'm logged in as "admin" / "secret"
		And the user "john" does not exist
    When I run ernest with "user create john secret"
    Then the output should contain "User created"

  Scenario: Admin creates a duplicate user
    Given I'm logged in as "admin" / "secret"
		And the user "john" exists
    When I run ernest with "user create john secret"
    Then the output should contain "Specified user already exists, please choose a different one."

  # NOTE: check my output
  Scenario: Admin creates a user with no password
    Given I'm logged in as "admin" / "secret"
		And the user "john" does not exist
    When I run ernest with "user create john"
    Then the output should contain "help?"

  # NOTE: check my output
  Scenario: Admin creates a user with no name
    Given I'm logged in as "admin" / "secret"
		And the user "john" does not exist
    When I run ernest with "user create"
    Then the output should contain "help?"

  Scenario: Unauthenticated user creates a user
    Given I logout
    When I run ernest with "user create john secret"
    Then the output should contain "You're not allowed to perform this action, please log in."
