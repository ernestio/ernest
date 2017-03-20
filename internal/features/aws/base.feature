@aws @aws_base
Feature: Service apply

  Scenario: Applying a basic service
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I start recording
    And I apply the definition "aws1.yml"
    And I stop recording
    Then an event "network.create.aws-fake" should be called exactly "1" times
    And all "network.create.aws-fake" messages should contain a field "_provider" with "aws-fake"
    And all "network.create.aws-fake" messages should contain a field "datacenter_region" with "fake"
    And all "network.create.aws-fake" messages should contain a field "vpc_id" with "fakeaws"
    And all "network.create.aws-fake" messages should contain a field "range" with "10.1.0.0/24"
    And all "network.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "up_to_16_characters_secret"
    And all "network.create.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "fake_up_to_16_characters"
    Then an event "firewall.create.aws-fake" should be called exactly "1" times
    And all "firewall.create.aws-fake" messages should contain a field "vpc_id" with "fakeaws"
    And all "firewall.create.aws-fake" messages should contain a field "datacenter_region" with "fake"
    And all "firewall.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "up_to_16_characters_secret"
    And all "firewall.create.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "fake_up_to_16_characters"
    And all "firewall.create.aws-fake" messages should contain a field "name" with "web-sg-1"
    And message "firewall.create.aws-fake" number "0" should contain "10.1.1.11/32" as json field "rules.egress.0.ip"
    And message "firewall.create.aws-fake" number "0" should contain "80" as json field "rules.egress.0.from_port"
    And message "firewall.create.aws-fake" number "0" should contain "80" as json field "rules.egress.0.to_port"
    And message "firewall.create.aws-fake" number "0" should contain "-1" as json field "rules.egress.0.protocol"
    And message "firewall.create.aws-fake" number "0" should contain "running" as json field "_state"
    Then an event "instance.create.aws-fake" should be called exactly "1" times
    And all "instance.create.aws-fake" messages should contain a field "_provider" with "aws-fake"
    And all "instance.create.aws-fake" messages should contain a field "datacenter_region" with "fake"
    And all "instance.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "up_to_16_characters_secret"
    And all "instance.create.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "fake_up_to_16_characters"
    And message "instance.create.aws-fake" number "0" should contain "foo" as json field "security_group_aws_ids.0"
    And all "instance.create.aws-fake" messages should contain a field "name" with "web-1"
    And all "instance.create.aws-fake" messages should contain a field "image" with "ami-6666f915"
    And all "instance.create.aws-fake" messages should contain a field "instance_type" with "e1.micro"
    And all "instance.create.aws-fake" messages should contain a field "_state" with "running"
