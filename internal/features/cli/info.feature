@info
Feature: Ernest info

  Scenario: A user gets info about current ernest instance
    Given I setup ernest with target "http://ernest.local"
    Given I'm logged in as "usr" / "secret123"
    When I run ernest with "info"
    Then The output should contain "http://ernest.local"
    And The output should contain "Current user : usr"
    When I logout
    And I run ernest with "info"
    Then The output should contain "http://ernest.local"
    And The output should not contain "Current user : usr"
