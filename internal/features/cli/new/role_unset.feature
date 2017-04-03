@role @role_unset
Feature: Ernest role unset

  Scenario: Role is revoked from a non existant user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    When I run ernest with "role unset admin fakeUser"
    Then the output should contain "User does not exist"

  Scenario: Non existant role is revoked from a user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    And the user "john" exists
    When I run ernest with "role unset fakeRole john"
    Then the output should contain "Role does not exist"

  Scenario: User revokes a role without providing a type and user
		Given I setup ernest with target "https://ernest.local"
		And I'm logged in as "admin" / "secret"
		When I run ernest with "role unset"
    Then the output should contain "help"

  # admin
  Scenario: User revokes admin role from another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the user "admin2" exists with admin role
    When I run ernest with "role unset admin admin2"
    Then the output should contain "You're not allowed to perform this action, please contact your administrator."

  Scenario: Admin revokes admin role without providing a user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    When I run ernest with "role unset admin"
    Then the output should contain "Please specify a user."

  Scenario: Admin revokes admin role from another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    And the user "admin2" has admin role
    When I run ernest with "role unset admin admin2"
    Then the output should contain "Role revoked"

  # project-level
  Scenario: User revokes a project level role from another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the user "john" has "<role>" role on project "myapp"
    And the user "jane" has "<unset-role>" role on project "myapp"
    When I run ernest with "role unset <unset-role> jane myapp"
    Then the output should contain "<output>"

    Examples:
      |role|unset-role|output|
      |owner|owner|Role revoked|
      |owner|reader|Role revoked|
      |reader|owner|You're not allowed to perform this action, please contact your administrator.|
      |reader|reader|You're not allowed to perform this action, please contact your administrator.|

  Scenario: Admin revokes a project level role from another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    And the user "john" has "<role>" role on project "myapp"
    When I run ernest with "role unset <role> john myapp"
    Then the output should contain "<output>"

    Examples:
      |role|output|
      |owner|Role revoked|
      |reader|Role revoked|

  # environment-level
  Scenario: User revokes an environment level role from another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the user "john" has "<prj-role>" role on project "myapp"
    And the user "john" has "<env-role>" role on environment "dev" in project "myapp"
		And the user "jane" has "<unset-role>" role on environment "dev" in project "myapp"
    When I run ernest with "role unset <unset-role> jane myapp dev"
    Then the output should contain "<output>"

    Examples:
      |prj-role|env-role|unset-role|output|
      |owner|owner|owner|Role revoked|
      |owner|owner|reader|Role revoked|
      |owner|reader|owner|You're not allowed to perform this action, please contact your administrator.|
      |owner|reader|reader|You're not allowed to perform this action, please contact your administrator.|
      |reader|owner|owner|Role revoked|
      |reader|reader|owner|You're not allowed to perform this action, please contact your administrator.|

  Scenario: Admin revokes an environment level role from another user
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    And the user "john" has "<role>" role on project "myapp" environment "dev"
    When I run ernest with "role unset <role> john myapp dev"
    Then the output should contain "<output>"

    Examples:
      |role|output|
      |owner|Role revoked|
      |reader|Role revoked|

  Scenario: Unauthenticated user assigns a role
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "role unset admin john"
    Then the output should contain "You're not allowed to perform this action, please log in."

