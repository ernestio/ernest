@project @project_info
Feature: Ernest project info

  Scenario: User with role lists project information
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the project "myapp" exists
    And the user "john" has "<role>" role on project "myapp"
    When I run ernest with "project info myapp"
    Then the output should contain "Name: myapp"
    And the output should contain "Provider:"
    And the output should contain "Environments:"
    And the output should contain "Members:"

	Examples:
	  |role|
	  |owner|
	  |reader|

  Scenario: User without role lists project information
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the project "myapp" exists
    And the user "jane" exists
    And the user "jane" has "owner" role on project "myapp"
    When I run ernest with "project info myapp"
    Then the output should contain "Project does not exist"
    
  Scenario: User lists project information for a non existant project
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "project info fakeProject"
    Then the output should contain "Project does not exist"

  Scenario: Unauthenticated user lists project information
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "project info myapp"
    Then the output should contain "You're not allowed to perform this action, please log in."
