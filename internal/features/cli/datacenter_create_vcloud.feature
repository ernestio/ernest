@project @project_create @project_create_vcloud
Feature: Ernest project create

  Scenario: Non logged vcloud project creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "project create vcloud"
    Then The output should contain "You should specify the project name"
    When I run ernest with "project create vcloud tmp_project"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged user vcloud project creation
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "project create vcloud"
    Then The output should contain "You should specify the project name"
    When I run ernest with "project create vcloud tmp_project"
    Then The output should contain "Please, fix the error shown below to continue"
    And The output should contain "- Specify a valid VCloud URL with --vcloud-url flag"
    And The output should contain "- Specify a valid VCloud vDC with --vdc flag"
    And The output should contain "- Specify a valid user name with --user"
    And The output should contain "- Specify a valid organization with --org"
    And The output should contain "- Specify a valid password with --password"
    When I run ernest with "project create vcloud --user usr --password xxxx --org MY-ORG-NAME --vcloud-url https://myernest.com --vdc tmp_project tmp_project"
    Then The output should contain "Project 'tmp_project' successfully created"
    When I run ernest with "project list"
    Then The output should contain "tmp_project"
    Then The output should contain "test"
    Then The output should contain "vcloud"
    Then The output should contain "https://myernest.com"
    Then The output should contain "MY-ORG-NAME"

  Scenario: Adding an already existing vcloud project
    Given I setup ernest with target "https://ernest.local"
    And the project "tmp_project" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "project create vcloud --user usr --password xxxx --org MY-ORG-NAME --vcloud-url https://myernest.com --vdc tmp_project tmp_project"
    And I run ernest with "project create vcloud --user usr --password xxxx --org MY-ORG-NAME --vcloud-url https://myernest.com --vdc tmp_project tmp_project"
    Then The output should contain "Project 'tmp_project' already exists, please specify a different name"
