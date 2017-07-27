@roles
Feature: Ernest role management

  Scenario: Non logged role creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "role set"
    Then The output should contain "You should provide role parameters, please run --help for help"
    When I run ernest with "role set --role owner"
    Then The output should contain "You should provide role parameters, please run --help for help"
    When I run ernest with "role set --role owner --user roler"
    Then The output should contain "You should specify at least a project name with (--project)"
    When I run ernest with "role set --role owner --user roler --project test_project"
    Then The output should contain "You're not allowed to perform this action, please log in"
    When I run ernest with "role set --role owner --user roler --project test_project --environment test_environment"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Plain user role creation
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And I run ernest with "project create tmp_project --type aws"
    When I run ernest with "role set --role reader --user roler --project tmp_project"
    Then The output should contain "User 'roler' has been authorized to read project tmp_projecte"
    When I'm logged in as "roler" / "secret123"
    And I run ernest with "project info tmp_project"
    Then The output should contain "usr"
    And The output should contain "roler"

