@project @project_update @project_update_aws
Feature: Ernest aws project update

  Scenario: Non logged aws project creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "project update aws"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Updating an existing aws project
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    And I run ernest with "project create aws --secret_access_key tmp_secret_access_key_up_to_16_chars --access_key_id tmp_secret_up_to_16_chars --region tmp_region tmp_project"
    And I run ernest with "project list"
    And The output should contain "tmp_project"
    When I run ernest with "project update aws tmp_project --secret_access_key tmp_secret_access_key_up_to_16_chars --access_key_id tmp_secret_up_to_16_chars"
    Then The output should contain "Project tmp_project successfully updated"
    And The aws project "tmp_project" credentials should be "tmp_secret_up_to_16_chars" and "tmp_secret_access_key_up_to_16_chars"

  Scenario: Updating an unexisting aws project
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "project update aws tmp_project --secret_access_key very_large_aws_token_string --access_key_id secret"
    Then The output should contain "Project 'tmp_project' does not exist, please specify a different project name"
