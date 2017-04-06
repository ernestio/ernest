@project @project_create
Feature: Ernest project create

	Background:
    Given I setup ernest with target "https://ernest.local"

  Scenario: User creates a project
    Given I'm logged in as "john" / "secret"
		And project "myapp" does not exists
    When I run ernest with "project create myapp"
    Then the output should contain "Project created"

  Scenario: User creates a project which already exists
    Given I'm logged in as "john" / "secret"
		And the project "myapp" exists
    When I run ernest with "project create myapp"
    Then the output should contain "Specified project already exists, please choose a different one."

  Scenario: User creates a project with no name
    Given I'm logged in as "john" / "secret"
    When I run ernest with "project create"
    Then the output should contain "help"

  Scenario: User creates a project with provider details
    Given I'm logged in as "john" / "secret"
		And project "myapp" does not exists
    When I run ernest with "project create myapp --provider <provider>"
    Then the output should contain "<output>"

    Examples:
			|provider|output|
      |aws --access-key 1234 --secret-key 5678|Project created|
      |aws --secret-key 5678|Missing flags: --access-key|
      |aws --access-key 1234|Missing flags: --secret-key|
      |aws|Missing flags: --access-key --secret-key|
      |vcd --url https://api.vcd.net --org myOrg --user john --password secret|Project created|
      |vcd --org myOrg --user john --password secret|Missing flags: --url|
      |vcd --url https://api.vcd.net --user john --password secret|Missing flags: --org|
      |vcd --url https://api.vcd.net --org myOrg --password secret|Missing flags: --user|
      |vcd --url https://api.vcd.net --org myOrg --user john|Missing flags: --password|
      |vcd|Missing flags: --url --org --user --password|
      |azure --id 1234 --secret 5678|Project created|
      |azure --secret 5678|Missing flags: --id|
      |azure --id 1234|Missing flags: --secret|
      |azure|Missing flags: --id --secret|

  Scenario: User creates a project with unknown provider type
    Given I'm logged in as "john" / "secret"
		And project "myapp" does not exists
    When I run ernest with "project create myapp --provider fakeProvider"
    Then the output should contain "Specified provider is unknown, please choose a different one."

  Scenario: Unauthenticated user creates a project with no name
    Given I logout
    When I run ernest with "project create"
    Then the output should contain "help"

  Scenario: Unauthenticated user creates a project
    Given I logout
    When I run ernest with "project create myapp"
    Then the output should contain "You're not allowed to perform this action, please log in."
