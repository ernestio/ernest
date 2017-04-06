@project @project_update
Feature: Ernest project update

	Background:
    Given I setup ernest with target "https://ernest.local"

  Scenario: User updates project provider details
    Given I'm logged in as "john" / "secret"
		And the user "john" has "<role>" role on project "myapp"
    When I run ernest with "project update myapp --provider <provider>"
    Then the output should contain "<output>"

	Examples:
	  |role|provider|output|
	  |owner|aws --access-key 1234 --secret-key 5678|Project updated|
		|owner|aws --secret-key 5678|Missing flags: --access-key|
		|owner|aws --access-key 1234|Missing flags: --secret-key|
		|owner|aws|Missing flags: --access-key --secret-key|
	  |reader|aws --access-key 1234 --secret-key 5678|You're not allowed to perform this action, please contact your administrator.|
		|owner|vcd --url https://api.vcd.net --org myOrg --user john --password secret|Project updated|
		|owner|vcd --org myOrg --user john --password secret|Missing flags: --url|
		|owner|vcd --url https://api.vcd.net --user john --password secret|Missing flags: --org|
		|owner|vcd --url https://api.vcd.net --org myOrg --password secret|Missing flags: --user|
		|owner|vcd --url https://api.vcd.net --org myOrg --user john|Missing flags: --password|
		|owner|vcd|Missing flags: --url --org --user --password|
		|reader|vcd --url https://api.vcd.net --org myOrg --user john --password secret|You're not allowed to perform this action, please contact your administrator.|
	  |owner|azure --id 1234 --secret 5678|Project updated|
		|owner|azure --secret 5678|Missing flags: --id|
		|owner|azure --id 1234|Missing flags: --secret|
		|owner|azure|Missing flags: --id --secret|
	  |reader|azure --id 1234 --secret 5678|You're not allowed to perform this action, please contact your administrator.|

  Scenario: User updates a project with unknown provider type
    Given I'm logged in as "john" / "secret"
		And the user "john" has "owner" role on project "myapp"
    When I run ernest with "project update myapp --provider fakeProvider"
    Then the output should contain "Specified provider is unknown, please choose a different one."

  Scenario: User updates a project which doesn't exists
    Given I'm logged in as "john" / "secret"
    When I run ernest with "project update fakeProject --provider aws --access-key foo --secret-key bar"
    Then the output should contain "Specified project does not exist, please choose a different one."

  Scenario: User updates a project without providing a project name
    Given I'm logged in as "john" / "secret"
    When I run ernest with "project update"
    Then the output should contain "help"

  Scenario: Unauthenticated user updates a project without providing a project name
    Given I logout
    When I run ernest with "project update"
    Then the output should contain "help"

  Scenario: Unauthenticated user updates a project
    Given I logout
    When I run ernest with "project update myapp --provider aws --access-key 1234 --secret-key 5678"
    Then the output should contain "You're not allowed to perform this action, please log in."
