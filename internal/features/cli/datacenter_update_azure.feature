@project @project_update @project_update_azure
Feature: Ernest azure project update

  Scenario: Non logged azure project creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "project update azure"
    Then The output should contain "Please provide required parameters"
    When I run ernest with "project update azure mine"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Updating an existing azure project
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "project create azure --subscription_id subid --client_id cliid --client_secret secret --region westus --tenant_id tenid --environment public tmp_project"
    And I run ernest with "project list"
    And The output should contain "tmp_project"
    When I run ernest with "project update azure --subscription_id u_subid --client_id u_cliid --client_secret secret --tenant_id u_tenid --environment u_public tmp_project"
    Then The output should contain "Project tmp_project successfully updated"
    And The azure project "tmp_project" credentials should be "u_subid", "u_cliid", "secret", "u_tenid" and "u_public"

  Scenario: Updating an unexisting azure project
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "project update azure --subscription_id u_subid --client_id u_cliid --client_secret secret --tenant_id u_tenid --environment u_public tmp_project"
    Then The output should contain "Project not found"
