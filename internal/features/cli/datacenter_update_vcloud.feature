@project @project_update @project_update_vcloud
Feature: Ernest vcloud project update

  Scenario: Non logged vcloud project creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "project update vcloud"
    Then The output should contain "Please provide required parameters"
    And The output should contain "ernest project update vcloud"
    When I run ernest with "project update vcloud something"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Updating an existing vcloud project
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    And I run ernest with "project create vcloud --user usr --password xxxx --org MY-ORG-NAME --vcloud-url https://myernest.com --vdc tmp_project tmp_project"
    And I run ernest with "project list"
    And The output should contain "tmp_project"
    When I run ernest with "project update vcloud tmp_project --user me --org MY-NEW-ORG --password secret"
    Then The output should contain "Project tmp_project successfully updated"

#  Scenario: Updating an unexisting vcloud project
#    Given I setup ernest with target "https://ernest.local"
#    And the project "tmp_project" does not exist
#    And I'm logged in as "usr" / "secret123"
#    When I run ernest with "project update vcloud tmp_project --user me --org MY-NEW-ORG --password secret"
#    Then The output should contain "Project not found"
