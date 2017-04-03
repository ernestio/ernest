@environment @environment_update
Feature: Ernest environment update

  Scenario: User with project role updates provider details on an environment
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And the user "john" has "<role>" role on project "myapp"
		And the user "john" has no role on environment "dev" in project "myapp"
    When I run ernest with "environment update myapp dev --provider aws --access-key foo --secret-key bar"
    Then the output should contain "<output>"

		Examples:
			|role|output|
			|owner|Environment updated|
			|reader|You're not allowed to perform this action, please contact your administrator.|


  Scenario: User with environment role updates provider details on an environment
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And the user "john" has "<role>" role on environment "dev" in project "myapp"
		And the user "john" has no role on project "myapp"
    When I run ernest with "environment update myapp dev --provider aws --access-key foo --secret-key bar"
    Then the output should contain "<output>"

		Examples:
			|role|output|
			|owner|Environment updated|
			|reader|You're not allowed to perform this action, please contact your administrator.|


  Scenario: User with both project and environment role updates provider details on an environment
    Given I setup ernest with target "https://ernest.local"
		And I'm logged in as "john" / "secret"
		And the user "john" has "<prj-role>" role on project "myapp"
		And the user "john" has "<env-role>" role on environment "dev" in project "myapp"
    When I run ernest with "environment update myapp dev --provider aws --access-key foo --secret-key bar"
    Then the output should contain "<output>"

		Examples:
			|prj-role|env-role|output|
			|owner|owner|Environment updated|
			|owner|reader|You're not allowed to perform this action, please contact your administrator.|
			|reader|owner|Environment updated|
			|reader|reader|You're not allowed to perform this action, please contact your administrator.|

  Scenario: User updates an environment with an unknown provider type
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And the user "john" has "owner" role on environment "dev" in project "myapp"
    When I run ernest with "environment update myapp dev --provider fakeProvider"
    Then the output should contain "Specified provider is unknown, please choose a different one."

  Scenario: User updates an environment which doesn't exists
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And the project "myapp" exists
    When I run ernest with "environment update myapp fakeEnvironment --provider aws --access-key foo --secret-key bar"
    Then the output should contain "Specified project does not exist, please choose a different one."

  Scenario: User updates an environment without providing an environment name
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    When I run ernest with "environment update"
    Then the output should contain "help"

  Scenario: Unuthenticated user updates an environment
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "environment update myapp dev --provider aws --access-key foo --secret-key bar"
    Then the output should contain "You're not allowed to perform this action, please log in."
