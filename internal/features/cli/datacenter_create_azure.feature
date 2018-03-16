@project @project_create @project_create_azure
Feature: Ernest project create

  Scenario: Non logged azure project creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "project create azure"
    Then The output should contain "Please provide required parameters"
    When I run ernest with "project create azure tmp_project"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged user azure project creation
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "project create azure"
    Then The output should contain "Please provide required parameter"
    When I run ernest with "project create azure tmp_project"
    Then The output should contain "Please, fix the error shown below to continue"
    And The output should contain "- Specify a valid --subscription_id flag"
    And The output should contain "- Specify a valid --client_id flag"
    And The output should contain "- Specify a valid --client_secret flag"
    And The output should contain "- Specify a valid --tenant_id flag"
    When I run ernest with "project create azure --subscription_id subid --client_id cliid --tenant_id tenid --client_secret clisec tmp_project"
    Then The output should contain "Project 'tmp_project' successfully created"
    When I run ernest with "project list"
    Then The output should contain "tmp_project"
    Then The output should contain "azure"

  Scenario: Adding an already existing azure project
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "project create azure --subscription_id subid --client_id cliid --tenant_id tenid --client_secret clisec tmp_project"
    And I run ernest with "project create azure --subscription_id subid --client_id cliid --tenant_id tenid --client_secret clisec tmp_project"
    Then The output should contain "Specified project already exists"
