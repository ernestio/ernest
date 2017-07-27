@environment @usage_report
Feature: Usage report

  Scenario: Usage report
    Given I setup a new environment name
    And I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And I apply the definition "aws1.yml"
    And I'm logged in as "ci_admin" / "secret123"
    When I run ernest with "usage --from 2017-01-01 --to 2099-01-01"
    Then The output line number "0" should contain "id"
    Then The output line number "0" should contain "service"
    Then The output line number "0" should contain "type"
    Then The output line number "0" should contain "instance"
