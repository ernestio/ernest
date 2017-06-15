@info
Feature: Ernest info

  Scenario: A user gets info about current ernest instance
    Given I setup ernest with target "http://ernest.local"
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "info"
