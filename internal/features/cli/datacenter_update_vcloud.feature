@datacenter @datacenter_update @datacenter_update_vcloud
Feature: Ernest vcloud datacenter update

  Scenario: Non logged vcloud datacenter creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "datacenter update vcloud"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Updating an existing vcloud datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "secret123"
    And I run ernest with "datacenter create vcloud --user usr --password xxxx --org MY-ORG-NAME --vse-url http://vse.url --vcloud-url https://myernest.com --public-network MY-PUBLIC-NETWORK tmp_datacenter"
    And I run ernest with "datacenter list"
    And The output should contain "tmp_datacenter"
    When I run ernest with "datacenter update vcloud tmp_datacenter --user me --org MY-NEW-ORG --password secret"
    Then The output should contain "Datacenter tmp_datacenter successfully updated"

  Scenario: Updating an unexisting vcloud datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "datacenter update vcloud tmp_datacenter --user me --org MY-NEW-ORG --password secret"
    Then The output should contain "Datacenter 'tmp_datacenter' does not exist, please specify a different datacenter name"
