@aws @aws_increment_instances_count
Feature: Service apply

  Scenario: Incrementing instances count
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I apply the definition "aws1.yml"
    And I start recording
    And I apply the definition "aws2.yml"
    And I stop recording
    Then an event "instance.create.aws-fake" should be called exactly "1" times
    And all "instance.create.aws-fake" messages should contain a field "_provider" with "aws-fake"
    And all "instance.create.aws-fake" messages should contain a field "datacenter_region" with "fake"
    And all "instance.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "up_to_16_characters_secret"
    And all "instance.create.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "fake_up_to_16_characters"
    And message "instance.create.aws-fake" number "0" should contain "foo" as json field "security_group_aws_ids.0"
    And all "instance.create.aws-fake" messages should contain a field "name" with "web-2"
    And all "instance.create.aws-fake" messages should contain a field "image" with "ami-6666f915"
    And all "instance.create.aws-fake" messages should contain a field "instance_type" with "e1.micro"
    And all "instance.create.aws-fake" messages should contain a field "_state" with "running"
