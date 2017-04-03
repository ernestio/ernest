@datacenter @datacenter_create @datacenter_create_vcloud
Feature: Ernest datacenter create

  Scenario: Non logged vcloud datacenter creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "datacenter create vcloud"
    Then The output should contain "You should specify the datacenter name"
    When I run ernest with "datacenter create vcloud tmp_datacenter"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged user vcloud datacenter creation
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "pwd"
    When I run ernest with "datacenter create vcloud"
    Then The output should contain "You should specify the datacenter name"
    When I run ernest with "datacenter create vcloud tmp_datacenter"
    Then The output should contain "Please, fix the error shown below to continue"
    And The output should contain "- Specify a valid VCloud URL with --vcloud-url flag"
    And The output should contain "- Specify a valid public network with --public-network flag"
    And The output should contain "- Specify a valid user name with --user"
    And The output should contain "- Specify a valid organization with --org"
    And The output should contain "- Specify a valid password with --password"
    When I run ernest with "datacenter create vcloud --user usr --password xxxx --org MY-ORG-NAME --vse-url http://vse.url --vcloud-url https://myernest.com --public-network MY-PUBLIC-NETWORK tmp_datacenter"
    Then The output should contain "Datacenter 'tmp_datacenter' successfully created"
    When I run ernest with "datacenter list"
    Then The output should contain "tmp_datacenter"
    Then The output should contain "test"
    Then The output should contain "vcloud"
    Then The output should contain "https://myernest.com"
    Then The output should contain "MY-PUBLIC-NETWORK"
    Then The output should contain "MY-ORG-NAME"

  Scenario: Adding an already existing vcloud datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "pwd"
    When I run ernest with "datacenter create vcloud --user usr --password xxxx --org MY-ORG-NAME --vse-url http://vse.url --vcloud-url https://myernest.com --public-network MY-PUBLIC-NETWORK tmp_datacenter"
    And I run ernest with "datacenter create vcloud --user usr --password xxxx --org MY-ORG-NAME --vse-url http://vse.url --vcloud-url https://myernest.com --public-network MY-PUBLIC-NETWORK tmp_datacenter"
    Then The output should contain "Datacenter 'tmp_datacenter' already exists, please specify a different name"


