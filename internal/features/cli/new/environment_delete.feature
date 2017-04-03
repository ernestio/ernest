@environment @environment_delete
Feature: Ernest environment delete

  Scenario: User with project role deletes an environment
		Given I setup ernest with target "https://ernest.local"
		And I'm logged in as "john" / "secret"
		And the user "john" has "<role>" role on project "myapp"
		And the user "john" has no role on environment "dev" in project "myapp"
		When I run ernest with "environment delete myapp dev"
		Then the output should contain "<output>"

		Examples:
			|role|output|
			|owner|Environment deleted|
			|reader|You're not allowed to perform this action, please contact your administrator.|

	Scenario: User with environment role deletes an environment
		Given I setup ernest with target "https://ernest.local"
		And I'm logged in as "john" / "secret"
		And the user "john" has "<role>" role on environment "dev" in project "myapp"
		And the user "john" has no role on project "myapp"
		When I run ernest with "environment delete myapp dev"
		Then the output should contain "<output>"

		Examples:
		  |role|output|
			|owner|Environment delete|
			|reader|You're not allowed to perform this action, please contact your administrator.|

	Scenario: User with both project and environment role deletes an environment
		Given I setup ernest with target "https://ernest.local"
		And I'm logged in as "john" / "secret"
		And the user "john" has "<prj-role>" role on project "myapp"
		And the user "john" has "<env-role>" role on environment "dev" in project "myapp"
		When I run ernest with "environment delete myapp dev"
		Then the output should contain "<output>"

		Examples:
			|prj-role|env-role|output|
			|owner|owner|Environment deleted|
			|owner|reader|You're not allowed to perform this action, please contact your administrator.|
			|reader|owner|Environment deleted|
			|reader|reader|You're not allowed to perform this action, please contact your administrator.|

  Scenario: User without role deletes an environment
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And the user "john" has no role on project "myapp"
		And the user "john" has no role on environment "dev" in project "myapp"
    When I run ernest with "environment delete myapp dev"
    Then the output should contain "Environment does not exist"

  Scenario: User deletes an environment which does not exist
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And the project "myapp" exists
    When I run ernest with "environment delete myapp fakeEnvironment"
    Then the output should contain "Specified environment does not exist, please choose a different one."

  Scenario: User deletes an environment with no name
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "environment delete"
    Then the output should contain "help"

  Scenario: Admin deletes an environment
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
		And the environment "dev" exists in project "myapp"
    When I run ernest with "environment delete myapp dev"
    Then the output should contain "Environment deleted"

  Scenario: Unuthenticated user deletes an environment
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "environment delete myapp dev"
    Then the output should contain "You're not allowed to perform this action, please log in."
