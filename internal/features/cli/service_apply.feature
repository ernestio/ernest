@service @service_apply
Feature: Service apply

  Scenario: Non logged service apply
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "service apply"
    Then The output should contain "You're not allowed to perform this action, please log in"
    When I run ernest with "service apply definitions/aws1.yml"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged service apply errors
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "service apply"
    Then The output should contain "You should specify a valid template path or store an ernest.yml on the current folder"
    When I run ernest with "service apply internal/definitions/unexisting_dc.yml"
    Then The output should contain "Specified datacenter does not exist"

  Scenario: Logged service apply
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The service "aws_test_service" does not exist
    When I apply the definition "aws1.yml"
    Then The output should contain "SUCCESS"

  Scenario: Logged service apply with internal file references
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The service "aws_test_service" does not exist
    When I apply the definition "aws-template1-unexisting.yml"
    Then The output should contain "Can't access referenced file"
