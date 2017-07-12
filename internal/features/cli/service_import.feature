@service @service_import
Feature: Service import

  Scenario: Non logged service import
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "service import"
    Then The output should contain "You're not allowed to perform this action, please log in"
    When I run ernest with "service import imported"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged service import errors
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "service import"
    Then The output should contain "You should specify an existing datacenter name"
    When I run ernest with "service import unexisting"
    Then The output should contain "You should specify a valid service name"

  Scenario: Logged service non existing import
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The service "imported" does not exist
    When I run ernest with "service import fakeaws imported"
    Then The output should contain regex "Ebs Volumes\s*2/2\s*Found"
    And The output should contain regex "Elbs\s*1/1\s*Found"
    And The output should contain regex "Firewalls\s*2/2\s*Found"
    And The output should contain regex "Instances\s*2/2\s*Found"
    And The output should contain regex "Internet Gateways\s*1/1\s*Found"
    And The output should contain regex "Nats\s*1/1\s*Found"
    And The output should contain regex "Networks\s*3/3\s*Found"
    And The output should contain regex "Rds Clusters\s*1/1\s*Found"
    And The output should contain regex "Rds Instances\s*1/1\s*Found"
    And The output should contain regex "Route53s\s*1/1\s*Found"
    And The output should contain regex "S3s\s*0/0\s*None"
    And The output should contain regex "Vpcs\s*1/1\s*Found"
    And The output should contain "Status: Imported"
