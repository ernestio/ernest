@federation
Feature: User authentication

  Scenario: Successful user authentication
    Given I setup ernest with target "https://ernest.local"
    And I have a federation provider configured
    When I log in as "john" / "secret123"
    Then the output should contain "Welcome back john"

  Scenario: Unsuccessful user authentication
    Given I setup ernest with target "https://ernest.local"
    And I have a federation provider configured
    When I log in as "jane" / "secret123"
    Then the output should contain "Authentication failed"
