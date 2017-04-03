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
    And The service "destroyable" does not exist
    And I apply the definition "destroyable.yml"
    And I wait for "5" seconds
    And I apply the definition "destroyable2.yml"
    When I run ernest with "service history destroyable"
    Then The output line number "3" should contain "destroyable"
    And The output line number "3" should contain "done"
    And The output line number "3" should contain "usr"
    And The output line number "5" should contain "destroyable"
    And The output line number "5" should contain "usr"

