@service @service_history
Feature: Service history

  Scenario: Non logged service history
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "service history"
    Then The output should contain "You're not allowed to perform this action, please log in"
    When I run ernest with "service destroy destroyable"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged service history unexisting
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "pwd"
    When I run ernest with "service history"
    Then The output should contain "You should specify an existing service name"
    When I run ernest with "service history unexisting"
    Then The output should contain "There are no registered builds for this service"

  Scenario: Logged service history
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "pwd"
    And the datacenter "test_dc" does not exist
    And I run ernest with "datacenter create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region --fake test_dc"
    And The service "destroyable" does not exist
    And I run ernest with "service apply internal/definitions/destroyable.yml"
    And I wait for "5" seconds
    And I run ernest with "service apply internal/definitions/destroyable2.yml"
    When I run ernest with "service history destroyable"
    Then The output line number "3" should contain "destroyable"
    And The output line number "3" should contain "done"
    And The output line number "3" should contain "usr"
    And The output line number "5" should contain "destroyable"
    And The output line number "5" should contain "usr"

