@project @project_list
Feature: Ernest project list

  Scenario: User lists projects
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "john" / "secret"
    And the project "johnApp" exists
    And the user "john" has "owner" role on project "johnApp"
    And the user "jane" exists
    And the project "janeApp" exists
    And the user "jane" has "owner" role on project "janeApp"
    When I run ernest with "project list"
    Then the output should contain "johnApp"
    But the output should not contain "janeApp"

  Scenario: Admin lists projects
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "admin" / "secret"
    And the user "john" exists
    And the project "myapp" exists
    And the user "john" has "owner" role on project "myapp"
    When I run ernest with "project list"
    Then the output should contain "myapp"

  Scenario: Unauthenticated user lists projects
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "project list"
    Then the output should contain "You're not allowed to perform this action, please log in."
