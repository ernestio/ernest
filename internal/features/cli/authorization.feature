@authorization
Feature: Ernest authorization management

  Scenario: bla
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "ci_admin" / "secret123"
    And I run ernest with "user create auth secret123"
    And I'm logged in as "auth" / "secret123"
    And The output should contain "Welcome back auth"
    When I run ernest with "project list"
    Then The output should contain "There are no projects created yet."
    When I run ernest with "env list"
    Then The output should contain "There are no environments created yet"
    When I run ernest with "project create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region auth_project"
    Then The output should contain "Project 'auth_project' successfully created"
    When I run ernest with "project list"
    Then The output should contain "auth_project"
    When I'm logged in as "ci_admin" / "secret123"
    And I run ernest with "role set -u auth -r reader -p fakeaws"
    When I'm logged in as "auth" / "secret123"
    And I run ernest with "project list"
    Then The output should contain "auth_project"
    And The output should contain "fakeaws"
    When I setup a new environment name "auth_env"
    And I apply the definition "aws1.yml"
    And I wait for "3" seconds
    And The output should contain "You don't have permissions to perform this action, please login as a resource owner"
    When I'm logged in as "ci_admin" / "secret123"
    And I run ernest with "role set -u auth -r owner -p fakeaws"
    When I'm logged in as "auth" / "secret123"
    And I apply the definition "aws1.yml"
    And I wait for "3" seconds
    And I run ernest with "env list"
    Then The output should contain "auth_env"
    When I'm logged in as "usr" / "secret123"
    And I run ernest with "env list"
    Then The output should not contain "auth_env"
    When I run ernest with "env info auth_project auth_env"
    Then The output should contain "Specified environment name does not exist"
    When I run ernest with "project info auth_project"
    Then The output should contain "403 Forbidden"




