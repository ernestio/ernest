@aws @add_nat_and_attach_a_network
Feature: Service apply

  Scenario: Add a nat gateway and attach a private network to it
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I apply the definition "aws11.yml"
    And I start recording
    And I apply the definition "aws12.yml"
    And I stop recording
    Then an event "nat.create.aws-fake" should be called exactly "1" times
    And all "nat.create.aws-fake" messages should contain a field "_provider" with "aws-fake"
    And all "nat.create.aws-fake" messages should contain a field "datacenter_region" with "fake"
    And all "nat.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "up_to_16_characters_secret"
    And all "nat.create.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "fake_up_to_16_characters"
    And all "nat.create.aws-fake" messages should contain a field "vpc_id" with "fakeaws"
    And all "nat.create.aws-fake" messages should contain a field "public_network" with "web"
    And message "nat.create.aws-fake" number "0" should contain "db" as json field "routed_networks.0"
    And all "nat.create.aws-fake" messages should contain a field "_state" with "running"
    Then an event "network.create.aws-fake" should be called exactly "1" times
    And all "network.create.aws-fake" messages should contain a field "_provider" with "aws-fake"
    And all "network.create.aws-fake" messages should contain a field "datacenter_region" with "fake"
    And all "network.create.aws-fake" messages should contain a field "vpc_id" with "fakeaws"
    And all "network.create.aws-fake" messages should contain a field "range" with "10.2.0.0/24"
    And all "network.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "up_to_16_characters_secret"
    And all "network.create.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "fake_up_to_16_characters"
