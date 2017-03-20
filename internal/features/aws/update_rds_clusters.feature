@aws @update_rds_clusters
Feature: Service apply

  Scenario: Updating rds clusters
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I apply the definition "aws16.yml"
    And I start recording
    And I apply the definition "aws17.yml"
    And I stop recording
    Then an event "rds_cluster.update.aws-fake" should be called exactly "1" times
    And all "rds_cluster.update.aws-fake" messages should contain a field "_provider" with "aws-fake"
    And all "rds_cluster.update.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "up_to_16_characters_secret"
    And all "rds_cluster.update.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "fake_up_to_16_characters"
    And all "rds_cluster.update.aws-fake" messages should contain a field "datacenter_region" with "fake"
    And all "rds_cluster.update.aws-fake" messages should contain a field "name" with "aurora"
    And all "rds_cluster.update.aws-fake" messages should contain a field "engine" with "aurora"
    And all "rds_cluster.update.aws-fake" messages should contain a field "database_name" with "test"
    And all "rds_cluster.update.aws-fake" messages should contain a field "database_username" with "test"
    And all "rds_cluster.update.aws-fake" messages should contain a field "database_password" with "testpass-2"
