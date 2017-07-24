@info
Feature: Ernest info

  Scenario: An authenticated user gets info about the ernest instance
    Given I setup ernest with target "http://ernest.local"
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "info"
    Then The output should contain regex "Target: http://ernest.local|http(s?)://127.0.0.1"
    And The output should contain "User: usr"
    And The output should contain regex "CLI Version: \d*\.\d*\.\d*"

  Scenario: An unauthenticated user gets info about the ernest instance
    Given I setup ernest with target "http://ernest.local"
#    And I'm logged in as "usr" / "secret123"
    And I logout
    When I run ernest with "info"
    Then The output should contain regex "Target: http://ernest.local|http(s?)://127.0.0.1"
    And The output should not contain "User: usr"
    And The output should contain regex "CLI Version: \d*\.\d*\.\d*"
