@project @project_update
Feature: Ernest project update

  Scenario: User updates provider details on a project
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
	And the project "myapp" exists
	And the user "john" has "<role>" role on project "myapp"
    When I run ernest with "project update myapp --provider aws --access-key foo --secret-key bar"
    Then the output should contain "<output>"

	Examples:
	  |role|output|
	  |owner|Project updated|
	  |reader|You're not allowed to perform this action, please contact your administrator.|

  Scenario: User updates a project with unknown provider type
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
	And the project "myapp" exists
	And the user "john" has "owner" role on project "myapp"
    When I run ernest with "project update myapp --provider fakeProvider"
    Then the output should contain "Specified provider is unknown, please choose a different one."

  Scenario: User updates a project which doesn't exists
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "project update myapp --provider aws --access-key foo --secret-key bar"
    Then the output should contain "Specified project does not exist, please choose a different one."

  Scenario: Unuthenticated user updates a project
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "project update myapp --provider aws --access-key foo --secret-key bar"
    Then the output should contain "You're not allowed to perform this action, please log in."
