@environment @environment_revert
Feature: Environment revert

  Background:
    Given I setup ernest with target "https://ernest.local"

  Scenario: User reverts a environment
    Given I'm logged in as "usr" / "secret123"
    And I apply the definition "service-revert.yml"
    And I apply the definition "service-revert2.yml"
    And I run ernest with "env revert fakeaws myService 1"
    When I run ernest with "env definition fakeaws myService"
    Then The output should contain "net-1"
    And The output should not contain "net-2"

  Scenario: User reverts a environment wihout providing a environment name or build ID
    Given I'm logged in as "usr" / "secret123"
    And I apply the definition "service-revert.yml"
    When I run ernest with "env revert myService"
    Then The output should contain "Please provide required parameters:"
    And The output should contain "$ ernest env revert <project> <env_name> <build_id>"

  Scenario: User reverts a environment providing an invalid build ID
    Given I'm logged in as "usr" / "secret123"
    And I apply the definition "service-revert.yml"
    When I run ernest with "env revert fakeaws myService 99"
    Then The output should contain "Specified environment build does not exist"

  Scenario: Unauthenticated user reverts a environment
    Given I logout
    When I run ernest with "env revert"
    Then The output should contain "$ ernest env revert <project> <env_name> <build_id>"
    When I run ernest with "env revert proj env build"
    Then The output should contain "You're not allowed to perform this action, please log in"
