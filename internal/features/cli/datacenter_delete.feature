@datacenter @datacenter_delete
Feature: Ernest datacenter create

  Scenario: Non logged vcloud datacenter creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "datacenter delete"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Deleting an existing datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "secret123"
    And I run ernest with "datacenter create vcloud --user usr --password xxxx --org MY-ORG-NAME --vse-url http://vse.url --vcloud-url https://myernest.com --public-network MY-PUBLIC-NETWORK tmp_datacenter"
    And I run ernest with "datacenter list"
    And The output should contain "tmp_datacenter"
    When I run ernest with "datacenter delete tmp_datacenter"
    Then The output should contain "Datacenter tmp_datacenter successfully removed"
    And I run ernest with "datacenter list"
    And The output should not contain "tmp_datacenter"

  Scenario: Deleting an unexisting datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "datacenter delete tmp_datacenter"
    Then The output should contain "Datacenter 'tmp_datacenter' does not exist, please specify a different datacenter name"

  Scenario: Deleting an existing datacenter with related services
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    And the datacenter "test_dc" does not exist
    And I'm logged in as "usr" / "secret123"
    And I run ernest with "datacenter create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region --fake test_dc"
    Then The output should contain "Datacenter 'test_dc' successfully created"
    And The service "aws_test_service" does not exist
    When I apply the definition "referenced.yml"
    And I run ernest with "datacenter list"
    And The output should contain "test_dc"
    And I run ernest with "datacenter delete test_dc"
    Then The output should contain "Existing services are referring to this datacenter."
