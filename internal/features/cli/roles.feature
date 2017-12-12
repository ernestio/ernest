@roles
Feature: Ernest role management

  Scenario: Non logged role creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "role set"
    Then The output should contain "Please provide a role with --role flag"
    When I run ernest with "role set --role owner"
    Then The output should contain "Please provide a user with --user flag"
    When I run ernest with "role set --role owner --user roler"
    Then The output should contain "Please provide a project with --project flag"
    When I run ernest with "role set --role owner --user roler --project test_project"
    Then The output should contain "You're not allowed to perform this action, please log in"
    When I run ernest with "role set --role owner --user roler --project test_project --environment test_environment"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Plain user role creation for a project
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And the project "tmp_project" does not exist
    And I run ernest with "project create aws tmp_project --region fake --secret_access_key fake_up_to_16_characters --access_key_id up_to_16_characters_secret --fake"
    When I run ernest with "role set --role reader --user ci_admin --project tmp_project"
    Then The output should contain "User 'ci_admin' has been authorized to read resource tmp_project"
    And I run ernest with "project info tmp_project"
    Then The output should contain "usr (owner)"
    And The output should contain "ci_admin (reader)"
    When I run ernest with "role unset --role reader --user ci_admin --project tmp_project"
    Then The output should contain "User 'ci_admin' has been unauthorized as tmp_project reader"
    And I run ernest with "project info tmp_project"
    Then The output should contain "usr (owner)"
    And The output should not contain "ci_admin (reader)"

  Scenario: Plain user role creation for an environment
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And I apply the definition "destroyable.yml"
    When I run ernest with "role set --role reader --user ci_admin --project fakeaws --environment destroyable"
    Then The output should contain "User 'ci_admin' has been authorized to read resource fakeaws/destroyable"
    And I run ernest with "env info fakeaws destroyable"
    Then The output should contain "usr (owner)"
    And The output should contain "ci_admin (reader)"
    When I run ernest with "role unset --role reader --user ci_admin --project fakeaws --environment destroyable"
    Then The output should contain "User 'ci_admin' has been unauthorized as fakeaws/destroyable reader"
    And I run ernest with "env info fakeaws destroyable"
    Then The output should contain "usr (owner)"
    And The output should not contain "ci_admin (reader)"

