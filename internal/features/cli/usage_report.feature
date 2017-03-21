@service @usage_report
Feature: Usage report

  Scenario: Usage report
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "pwd"
    And the datacenter "test_dc" does not exist
    And I run ernest with "datacenter create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region --fake test_dc"
    And The service "aws_test_service" does not exist
    And I run ernest with "service apply internal/definitions/aws1.yml"
    When I run ernest with "usage"
    Then The output line number "0" should contain "id"
    Then The output line number "0" should contain "service"
    Then The output line number "0" should contain "type"
    Then The output line number "0" should contain "instance"
