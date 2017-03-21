@service @service_info
Feature: Ernest service info

  Scenario: Non logged user info
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "service info"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged user info
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "pwd"
    And the datacenter "test_dc" does not exist
    And I run ernest with "datacenter create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region --fake test_dc"
    And The service "destroyable" does not exist
    And I run ernest with "service apply internal/definitions/destroyable.yml"
    When I run ernest with "service info destroyable"
    Then The output should contain "Name : destroyable"
    And The output should contain "ELBs (empty)"
    And The output should contain "VPC : fakeaws"
    And The output should contain "Networks:"
    And The output should contain "| test_dc-destroyable-web | foo |"
    And The output should contain "NAT gateways (empty)"
    And The output should contain "Security groups (empty)"

