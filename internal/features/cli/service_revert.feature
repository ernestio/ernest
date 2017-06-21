@service @service_revert
Feature: Service revert

  Background:
    Given I setup ernest with target "https://ernest.local"

  Scenario: User reverts a service
    Given I'm logged in as "usr" / "secret123"
    And I apply the definition "service-revert.yml"
    And I apply the definition "service-revert2.yml"
    And I run ernest with "service revert myService 1"
    When I run ernest with "service definition myService"
    Then The output should contain "net-1"
    And The output should not contain "net-2"

  Scenario: User reverts a service wihout providing a service name or build ID
    Given I'm logged in as "usr" / "secret123"
    And I apply the definition "service-revert.yml"
    When I run ernest with "service revert myService"
    Then The output should contain "Please specify a service name and build ID"

  Scenario: User reverts a service providing an invalid build ID
    Given I'm logged in as "usr" / "secret123"
    And I apply the definition "service-revert.yml"
    When I run ernest with "service revert myService 99"
    Then The output should contain "Invalid build ID"

  Scenario: Unauthenticated user reverts a service
    Given I logout
    When I run ernest with "service revert"
    Then The output should contain "You're not allowed to perform this action, please log in"
