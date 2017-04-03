@environment @environment_list
Feature: Ernest environment list

  Scenario: User with project role lists environments
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And the user "john" has "<role>" role on project "myapp"
		And the user "john" has no role on environment "dev" in project "myapp"
    When I run ernest with "environment list"
    Then the output should contain "dev"

    Examples:
      |role|
      |owner|
      |reader|

  Scenario: User with environment role lists environments
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
		And the user "john" has "<role>" role on environment "dev" in project "myapp"
		And the user "john" has no role on project "myapp"
    When I run ernest with "environment list"
    Then the output should contain "dev"

    Examples:
			|role|
			|owner|
			|reader|

  Scenario: User with both project and environment role lists environments
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the user "john" has "<prj-role>" role on project "myapp"
		And the user "john" has "<env-role>" role on environment "dev" in project "myapp"
    When I run ernest with "environment list"
    Then the output should contain "dev"

    Examples:
			|prj-role|env-role|
			|owner|owner|
			|owner|reader|
			|reader|owner|
			|reader|reader|

  Scenario: Admin lists environments
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    And the user "admin" has no role on project "myapp"
    When I run ernest with "project list"
    Then the output should contain "myapp"

  Scenario: Unauthenticated user lists environments
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "environment list"
    Then the output should contain "You're not allowed to perform this action, please log in."
