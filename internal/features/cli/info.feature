@info
Feature: Ernest info

  Scenario: An authenticated user gets info about the ernest instance
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "info"
    Then The output should contain "Target:"
    And The output should contain "https://ernest.local"
    And The output should contain "User:"
    And The output should contain "usr"
    And The output should contain "CLI Version:"
    And The output should contain regex " \d*\.\d*\.\d*"

  Scenario: An unauthenticated user gets info about the ernest instance
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "info"
    Then The output should contain "Target:"
    And The output should contain "https://ernest.local"
    And The output should not contain "usr"
    And The output should contain "CLI Version:"
    And The output should contain regex "\d*\.\d*\.\d*"
