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
    Then The output should contain "Ebs Volumes          2/2   Found"
    And The output should contain "Elbs                 1/1   Found"
    And The output should contain "Firewalls            2/2   Found"
    And The output should contain "Instances            2/2   Found"
    And The output should contain "Internet Gateways    1/1   Found"
    And The output should contain "Nats                 1/1   Found"
    And The output should contain "Networks             3/3   Found"
    And The output should contain "Rds Clusters         1/1   Found"
    And The output should contain "Rds Instances        1/1   Found"
    And The output should contain "Route53s             1/1   Found"
    And The output should contain "S3s                  0/0   None"
    And The output should contain "Vpcs                 1/1   Found"
    And The output should contain "Status: Imported"
