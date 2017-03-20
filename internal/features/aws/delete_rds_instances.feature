@aws @delete_rds_instances
Feature: Service apply

  Scenario: Updating rds instances
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I apply the definition "aws19.yml"
    And I start recording
    And I apply the definition "aws20.yml"
    And I stop recording
    Then an event "rds_instance.delete.aws-fake" should be called exactly "1" times
    And all "rds_instance.delete.aws-fake" messages should contain a field "_provider" with "aws-fake"
    And all "rds_instance.delete.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "up_to_16_characters_secret"
    And all "rds_instance.delete.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "fake_up_to_16_characters"
    And all "rds_instance.delete.aws-fake" messages should contain a field "datacenter_region" with "fake"
    And all "rds_instance.delete.aws-fake" messages should contain a field "name" with "test-1"
    And all "rds_instance.delete.aws-fake" messages should contain a field "size" with "db.r3.xlarge"
    And all "rds_instance.delete.aws-fake" messages should contain a field "cluster" with "aurora"
