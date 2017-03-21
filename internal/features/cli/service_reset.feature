@service @service_reset
Feature: Ernest service reset

  Scenario: Non logged user reset
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "service reset"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged user reset
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "pwd"
    And the datacenter "test_dc" does not exist
    And I run ernest with "datacenter create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region --fake test_dc"
    And The service "destroyable" does not exist
    And I run ernest with "service apply internal/definitions/destroyable.yml"
    When I run ernest with "service reset destroyable"
    Then The output should contain "The service 'destroyable' can't be resetted as is on status 'done'"
    And I force "destroyable" to be on status "in_progress"
    When I run ernest with "service list"
    And The output line number "3" should contain "destroyable"
    And The output line number "3" should contain "in_progress"
    And The output line number "3" should contain "usr"
    When I run ernest with "service reset destroyable"
    Then The output should contain "You've successfully resetted the service 'destroyable'"
    When I run ernest with "service list"
    And The output line number "3" should contain "destroyable"
    And The output line number "3" should contain "errored"
    And The output line number "3" should contain "usr"
    When I run ernest with "service reset destroyable"
    Then The output should contain "The service 'destroyable' can't be resetted as is on status 'errored'"

