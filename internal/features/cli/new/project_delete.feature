@project @project_delete
Feature: Ernest project delete

	Background:
    Given I setup ernest with target "https://ernest.local"

  Scenario: User with role deletes a project with no environments
    Given I'm logged in as "john" / "secret"
		And the user "john" has "<role>" role on project "myapp"
    When I run ernest with "project delete myapp"
		Then the output should contain "<output>"

		Examples:
		  |role|output|
		  |owner|Project deleted|
		  |reader|You're not allowed to perform this action, please contact your administrator.|

	Scenario: User with role deletes a project with environments
    Given I'm logged in as "john" / "secret"
		And the user "john" has "<role>" role on project "myapp"
		And the environment "dev" exists in project "myapp"
    When I run ernest with "project delete myapp"
		Then the output should contain "<output>"

		Examples:
		  |role|output|
		  |owner|Project cannot be deleted, still has environment associations.|
		  |reader|You're not allowed to perform this action, please contact your administrator.|

  Scenario: User without role deletes a project
    Given I'm logged in as "john" / "secret"
		And the user "john" has no role on project "myapp"
    When I run ernest with "project delete myapp"
    Then the output should contain "Project does not exist"

  Scenario: User deletes a project which does not exist
    Given I'm logged in as "john" / "secret"
    When I run ernest with "project delete fakeProject"
    Then the output should contain "Specified project does not exist, please choose a different one."

  Scenario: User deletes a project with no name
    Given I'm logged in as "john" / "secret"
    When I run ernest with "project delete"
    Then the output should contain "help"

  Scenario: Admin deletes a project with no environments
    Given I'm logged in as "admin" / "secret"
		And the project "myapp" exists
    When I run ernest with "project delete myapp"
    Then the output should contain "Project deleted"

  Scenario: Admin deletes a project with environments
    Given I'm logged in as "admin" / "secret"
		And the environment "dev" in project "myapp" exists
    When I run ernest with "project delete myapp"
    Then the output should contain "Project cannot be deleted, still has environment associations."

  Scenario: Unauthenticated user deletes a project with no name
    Given I logout
    When I run ernest with "project delete"
    Then the output should contain "help"

  Scenario: Unauthenticated user deletes a project
    Given I logout
    When I run ernest with "project delete myapp"
    Then the output should contain "You're not allowed to perform this action, please log in."
