@service @service_destroy
Feature: Service destroy

  Scenario: Non logged service destroy
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "service destroy"
    Then The output should contain "You're not allowed to perform this action, please log in"
    When I run ernest with "service destroy destroyable"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged service destroy unexisting
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "service destroy"
    Then The output should contain "You should specify an existing service name"
    When I run ernest with "service destroy unexisting --yes"
    Then The output should contain "Specified service name does not exist"

  Scenario: Logged service destroy
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The service "destroyable" does not exist
    And I apply the definition "destroyable.yml"
    When I run ernest with "service destroy destroyable --yes"
    Then The output should not contain "Specified service name does not exist"
    And I wait for "1" seconds
    When I run ernest with "service destroy destroyable --yes"
    Then The output should contain "Specified service name does not exist"
