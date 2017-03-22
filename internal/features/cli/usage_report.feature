@service @usage_report
Feature: Usage report

  Scenario: Usage report
    Given I setup a new service name
    And I setup ernest with target "https://ernest.local"
    And I'm logged in as "ci_admin" / "pwd"
    And I apply the definition "aws1.yml"
    When I run ernest with "usage"
    Then The output line number "0" should contain "id"
    Then The output line number "0" should contain "service"
    Then The output line number "0" should contain "type"
    Then The output line number "0" should contain "instance"
