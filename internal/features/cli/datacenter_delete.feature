@project @project_delete
Feature: Ernest project create

  Scenario: Non logged vcloud project creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "project delete"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Deleting an existing project
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    And I run ernest with "project create vcloud --user usr --password xxxx --org MY-ORG-NAME --vse-url http://vse.url --vcloud-url https://myernest.com --public-network MY-PUBLIC-NETWORK tmp_project"
    And I run ernest with "project list"
    And The output should contain "tmp_project"
    When I run ernest with "project delete tmp_project"
    Then The output should contain "Project tmp_project successfully removed"
    And I run ernest with "project list"
    And The output should not contain "tmp_project"

  Scenario: Deleting an unexisting project
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "project delete tmp_project"
    Then The output should contain "Project 'tmp_project' does not exist, please specify a different project name"

  Scenario: Deleting an existing project with related environments
    Given I setup ernest with target "https://ernest.local"
    And I setup a new environment name
    And the project "test_dc" does not exist
    And I'm logged in as "usr" / "secret123"
    And I run ernest with "project create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region --fake test_dc"
    Then The output should contain "Project 'test_dc' successfully created"
    And The environment "aws_test_environment" does not exist
    When I apply the definition "referenced.yml"
    And I run ernest with "project list"
    And The output should contain "test_dc"
    And I run ernest with "project delete test_dc"
    Then The output should contain "Existing environments are referring to this project."
