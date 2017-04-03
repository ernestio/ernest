@environment @environment_info
Feature: Ernest environment info

  Scenario: User with project role lists environment information
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the user "john" has "<role>" role on project "myapp"
		And the user "john" has no role on environment "dev" in project "myapp"
    When I run ernest with "environment info myapp dev"
    Then the output should contain "myapp"
    And the output should contain "dev"

	Examples:
	  |role|
	  |owner|
	  |reader|

  Scenario: User with environment role lists environment information
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the user "john" has "<role>" role on environment "dev" in project "myapp"
		And the user "john" has no role on project "myapp"
    When I run ernest with "environment info myapp dev"
    Then the output should contain "myapp"
    And the output should contain "dev"

	Examples:
	  |role|
	  |owner|
	  |reader|

  Scenario: User with both project and environment roles lists environment information
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
	And the user "john" has "<prj-role>" role on project "myapp"
    And the user "john" has "<env-role>" role on environment "dev" in project "myapp"
    When I run ernest with "environment info myapp dev"
    Then the output should contain "myapp"
    And the output should contain "dev"

	Examples:
	  |prj-role|env-role|
	  |owner|owner|
	  |owner|reader|
	  |reader|owner|
	  |reader|reader|

  Scenario: User without role lists environment information
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And the user "john" has no role on environment "dev" in project "myapp"
    When I run ernest with "environment info myapp dev"
    Then the output should contain "Environment does not exist"
    
  Scenario: User lists environment information for a non existant environment
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And the project "myapp" exists
    When I run ernest with "environment info myapp fakeEnvironment"
    Then the output should contain "Environment does not exist"

  Scenario: User lists environment information without providing an environment name
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "environment info"
    Then the output should contain "help"

  Scenario: Unauthenticated user lists environment information
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "environment info myapp dev"
    Then the output should contain "You're not allowed to perform this action, please log in."
