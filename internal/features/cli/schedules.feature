@schedules
Feature: Ernest schedule management

  Scenario: Non logged schedule creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "env schedule list"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Plain user schedule creation for an environment
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And I setup a new environment name
    And I run ernest with "environment create fakeaws $(name) --secret_access_key tmp_secret_access_key_2 --access_key_id tmp_secret_up_to_16_chars_2"
    And I run ernest with "env schedule list fakeaws"
    Then The output should contain "You must provide the new environment name"
    And I run ernest with "env schedule list fakeaws"
    Then The output should contain "You must provide the new environment name"
    When I run ernest with "env schedule list nonexistent nonexistent"
    Then The output should contain "Environment does not exist!"
    And I run ernest with "env schedule list fakeaws $(name)"
    Then The output should contain "There are no schedules created for this environment"
    And The output should contain "please use 'ernest env schedule add' to create a new one"
    And I run ernest with "env schedule add fakeaws $(name) my_schedule --sync_interval @monday --action power_on"
    And I run ernest with "env schedule list fakeaws $(name)"
    And The output should contain "my_schedule"
    And The output should contain "@monday"
    And The output should contain "power_on"
    And I run ernest with "env schedule rm fakeaws $(name) my_schedule"
    And I run ernest with "env schedule list fakeaws $(name)"
    And The output should not contain "my_schedule"
