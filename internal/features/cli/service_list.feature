@service @service_list
Feature: Ernest service list

  Scenario: Non logged user listing
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "service list"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged user listing
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "pwd"
    And the datacenter "test_dc" does not exist
    And I run ernest with "datacenter create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region --fake test_dc"
    And The service "destroyable" does not exist
    And I run ernest with "service apply internal/definitions/destroyable.yml"
    When I run ernest with "service list"
    Then The output should contain "destroyable"
    And The output should not contain "errored"
    And The output should contain "usr"

