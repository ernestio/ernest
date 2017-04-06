@project @project_list
Feature: Ernest project list

	Background:
    Given I setup ernest with target "https://ernest.local"

  Scenario: User lists projects
    Given I'm logged in as "john" / "secret"
    And the user "john" has "owner" role on project "myapp"
		And the user "john" has no role on project "myapp2"
    When I run ernest with "project list"
    Then the output should contain "myapp"
    But the output should not contain "myapp2"

  Scenario: Admin lists projects
    Given I'm logged in as "admin" / "secret"
    And the user "admin" has no role on project "myapp"
    When I run ernest with "project list"
    Then the output should contain "myapp"

  Scenario: Unauthenticated user lists projects
    Given I logout
    When I run ernest with "project list"
    Then the output should contain "You're not allowed to perform this action, please log in."
