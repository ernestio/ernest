@environment @environment_create
Feature: Ernest environment create

  Scenario: User with project role creates an environment
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the user "john" has "<role>" role on project "myapp"
    And the environment "dev" does not exist in project "myapp"
    When I run ernest with "environment create myapp dev"
    Then the output should contain "<output>"

    Examples:
      |role|output|
      |owner|Environment created|
      |reader|You're not allowed to perform this action, please contact your administrator.|

  Scenario: User creates an environment which already exists
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the environment "dev" exists in project "myapp"
    When I run ernest with "environment create myapp dev"
    Then the output should contain "Specified project already exists, please choose a different one."

  Scenario: User creates an environment with no name
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "environment create"
    Then the output should contain "help"

  Scenario: User creates an environment with provider details
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the environment "dev" does not exist in project "myapp"
    When I run ernest with "environment create myapp dev --provider aws --access-key foo --secret-key bar"
    Then the output should contain "Environment created"

  Scenario: User creates an environment with unknown provider type
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the environment "dev" does not exist in project "myapp"
    When I run ernest with "environment create myapp dev --provider fakeProvider"
    Then the output should contain "Specified provider is unknown, please choose a different one."

  Scenario: Unuthenticated user creates an environment
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "environment create myapp"
    Then the output should contain "You're not allowed to perform this action, please log in."
