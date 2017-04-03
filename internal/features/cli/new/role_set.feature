@role @role_set
Feature: Ernest role set

  Scenario: Role is assigned to a non existant user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    When I run ernest with "role set admin fakeUser"
    Then the output should contain "User does not exist"

  Scenario: Non existant role is assigned to user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    And the user "john" exists
    When I run ernest with "role set fakeRole john"
    Then the output should contain "Role does not exist"

  Scenario: User assigns a role without providing a type and user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    When I run ernest with "role set"
    Then the output should contain "help"

  # admin
  Scenario: User assigns admin role to another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the user "jane" exists
    When I run ernest with "role set admin jane"
    Then the output should contain "You're not allowed to perform this action, please contact your administrator."

  Scenario: Admin assigns admin role without providing a user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    When I run ernest with "role set admin"
    Then the output should contain "Please specify a user."

  Scenario: Admin assigns admin role to another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    And the user "admin2" exists
    When I run ernest with "role set admin admin2"
    Then the output should contain "Role assigned"

  # project-level
  Scenario: User assigns a project level role to another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the user "john" has "<role>" role on project "myapp"
		And the user "jane" has no role on project "myapp"
    When I run ernest with "role set <set-role> jane myapp"
    Then the output should contain "<output>"

    Examples:
      |role|set-role|output|
      |owner|owner|Role assigned|
      |owner|reader|Role assigned|
      |reader|owner|You're not allowed to perform this action, please contact your administrator.|
      |reader|reader|You're not allowed to perform this action, please contact your administrator.|

  Scenario: Admin assigns a project level role to another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
		And the user "john" has no role on project "myapp"
    When I run ernest with "role set <role> john myapp"
    Then the output should contain "<output>"

    Examples:
      |role|output|
      |owner|Role assigned|
      |reader|Role assigned|

  # environment-level
  Scenario: User assigns an environment level role to another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the user "john" has "<prj-role>" role on project "myapp"
		And the user "john" has "<env-role>" role on environment "dev" in project "myapp"
		And the user "jane" has no role on environment "dev" in project "myapp"
    When I run ernest with "role set <set-role> jane myapp dev"
    Then the output should contain "<output>"

    Examples:
      |prj-role|env-role|set-role|output|
      |owner|owner|owner|Role assigned|
      |owner|owner|reader|Role assigned|
      |owner|reader|owner|You're not allowed to perform this action, please contact your administrator.|
      |owner|reader|reader|You're not allowed to perform this action, please contact your administrator.|
      |reader|owner|owner|Role assigned|
      |reader|reader|owner|You're not allowed to perform this action, please contact your administrator.|

  Scenario: Admin assigns an environment level role to another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    And the environment "dev" in project "myapp" exists
		And the user "john" has no role on project "myapp"
    When I run ernest with "role set <role> john myapp dev"
    Then the output should contain "<output>"

    Examples:
      |role|output|
      |owner|Role assigned|
      |reader|Role assigned|

  Scenario: Unauthenticated user assigns a role
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "role set admin john"
    Then the output should contain "You're not allowed to perform this action, please log in."

