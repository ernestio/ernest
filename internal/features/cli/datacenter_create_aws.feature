@project @project_create @project_create_aws
Feature: Ernest project create

  Scenario: Non logged aws project creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "project create aws"
    Then The output should contain "Please provide required parameters"
    When I run ernest with "project create aws tmp_project"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged user aws project creation
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "project create aws"
    Then The output should contain "Please provide required parameters"
    When I run ernest with "project create aws tmp_project"
    Then The output should contain "Please, fix the error shown below to continue"
    And The output should contain "- Specify a valid --secret_access_key flag"
    And The output should contain "- Specify a valid --access_key_id flag"
    And The output should contain "- Specify a valid --region flag"
    When I run ernest with "project create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region tmp_project"
    Then The output should contain "Project 'tmp_project' successfully created"
    When I run ernest with "project list"
    Then The output should contain "tmp_project"
    Then The output should contain "tmp_region"
    Then The output should contain "aws"

  Scenario: Adding an already existing aws project
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "project create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region tmp_project"
    And I run ernest with "project create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region tmp_project"
    Then The output should contain "Specified project already exists"
