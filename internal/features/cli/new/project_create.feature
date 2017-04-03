@project @project_create
Feature: Ernest project create

  Scenario: User creates a project
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And project "myapp" does not exists
    When I run ernest with "project create myapp"
    Then the output should contain "Project created"

  Scenario: User creates a project which already exists
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And the project "myapp" exists
    When I run ernest with "project create myapp"
    Then the output should contain "Specified project already exists, please choose a different one."

  Scenario: User creates a project with no name
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "project create"
    Then the output should contain "help"

  Scenario: User creates a project with provider details
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And project "myapp" does not exists
    When I run ernest with "project create myapp --provider aws --access-key foo --secret-key bar"
    Then the output should contain "Project created"

  Scenario: User creates a project with unknown provider type
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And project "myapp" does not exists
    When I run ernest with "project create myapp --provider fakeProvider"
    Then the output should contain "Specified provider is unknown, please choose a different one."

  Scenario: Unuthenticated user creates a project
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "project create myapp"
    Then the output should contain "You're not allowed to perform this action, please log in."
