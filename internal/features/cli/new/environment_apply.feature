@environment @environment_apply
Feature: Ernest environment apply

	Background:
    Given I setup ernest with target "https://ernest.local"

  Scenario: User with project role applies a manifest
    Given I'm logged in as "john" / "secret"
    And the user "john" has "<role>" role on project "myapp"
		And the user "john" has no role on environment "dev" in project "myapp"
    When I run ernest with "environment apply definitions/test.yml"
    Then the output should contain "<output>"

    Examples:
      |role|output|
      |owner|Environment applied|
      |reader|You're not allowed to perform this action, please contact your administrator.|

	Scenario: User with environment role applies a manifest
    Given I'm logged in as "john" / "secret"
    And the user "john" has "<role>" role on environment "dev" in project "myapp"
    And the user "john" has no role on project "myapp"
    When I run ernest with "environment apply definitions/test.yml"
    Then the output should contain "<output>"

    Examples:
    	|role|output|
      |owner|Environment applied|
      |reader|You're not allowed to perform this action, please contact your administrator.|

  Scenario: User with both project and environment role applies a manifest
    Given I'm logged in as "john" / "secret"
    And the user "john" has "<prj-role>" role on project "myapp"
    And the user "john" has "<env-role>" role on environment "dev" in project "myapp"
    When I run ernest with "environment apply definitions/test.yml"
    Then the output should contain "<output>"

    Examples:
    	|prj-role|env-role|output|
      |owner|owner|Environment applied|
      |owner|reader|You're not allowed to perform this action, please contact your administrator.|
      |reader|owner|Environment applied|
      |reader|reader|You're not allowed to perform this action, please contact your administrator.|

  Scenario: User applies a manifest with missing project name
    Given I'm logged in as "john" / "secret"
    When I run ernest with "environment apply definitions/missing-project.yml"
    Then the output should contain "Project name missing from manifest"

  Scenario: User applies a manifest with missing environment name
    Given I'm logged in as "john" / "secret"
    When I run ernest with "environment apply definitions/missing-environment.yml"
    Then the output should contain "Environment name missing from manifest"

  Scenario: User applies a manifest with unknown project name
    Given I'm logged in as "john" / "secret"
    When I run ernest with "environment apply definitions/unknown-project.yml"
    Then the output should contain "Project name in manifest does not exist"

  Scenario: User applies a manifest with unknown environment name
    Given I'm logged in as "john" / "secret"
    When I run ernest with "environment apply definitions/unknown-environment.yml"
    Then the output should contain "Environment name in manifest does not exist"
				
	Scenario: User applies an incorrectly formatted manifest
    Given I'm logged in as "john" / "secret"
    When I run ernest with "environment apply definitions/bad.yml"
    Then the output should contain "Error parsing manifest, please check the manifest is a valid YAML format."

	Scenario: User specifies a non-existent manifest file
    Given I'm logged in as "john" / "secret"
    When I run ernest with "environment apply definitions/missing.yml"
    Then the output should contain "Manifest 'missing.yml' does not exist"

  Scenario: User applies an environment with no manifest
    Given I'm logged in as "john" / "secret"
    When I run ernest with "environment apply"
    Then the output should contain "help"

  Scenario: Unauthenticated user applies an environment with no manifest
    Given I logout
    When I run ernest with "environment apply"
    Then the output should contain "help"

  Scenario: Unauthenticated user applies a manifest
    Given I logout
    When I run ernest with "environment apply definitions/test.yml"
    Then the output should contain "You're not allowed to perform this action, please log in."
