@logout
Feature: Ernest logout

  Scenario: Logout logged in user
    Given I setup ernest with target "https://ernest.local"
    When I'm logged in as "usr" / "secret123"
    And I logout
    Then The output should contain "Bye."
    When I run ernest with "info"
    Then The output should not contain "usr"
    When I run ernest with "user list"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logout non logged in user
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I logout
    Then The output should contain "You're not allowed to perform this action, please log in"
