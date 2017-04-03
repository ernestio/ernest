@aws @add_ingress_security_group
Feature: Service apply

  Scenario: Add an ingress security group to an instance
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I apply the definition "aws4.yml"
    And I start recording
    And I apply the definition "aws5.yml"
    And I stop recording
    Then an event "firewall.update.aws-fake" should be called exactly "1" times
    And all "firewall.update.aws-fake" messages should contain a field "vpc_id" with "fakeaws"
    And all "firewall.update.aws-fake" messages should contain a field "datacenter_region" with "fake"
    And all "firewall.update.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "up_to_16_characters_secret"
    And all "firewall.update.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "fake_up_to_16_characters"
    And all "firewall.update.aws-fake" messages should contain a field "name" with "web-sg-1"
    And message "firewall.update.aws-fake" number "0" should contain "10.1.1.11/32" as json field "rules.egress.0.ip"
    And message "firewall.update.aws-fake" number "0" should contain "80" as json field "rules.egress.0.from_port"
    And message "firewall.update.aws-fake" number "0" should contain "80" as json field "rules.egress.0.to_port"
    And message "firewall.update.aws-fake" number "0" should contain "-1" as json field "rules.egress.0.protocol"
    And message "firewall.update.aws-fake" number "0" should contain "10.1.1.11/32" as json field "rules.ingress.1.ip"
    And message "firewall.update.aws-fake" number "0" should contain "22" as json field "rules.ingress.1.from_port"
    And message "firewall.update.aws-fake" number "0" should contain "22" as json field "rules.ingress.1.to_port"
    And message "firewall.update.aws-fake" number "0" should contain "-1" as json field "rules.ingress.1.protocol"
    And message "firewall.update.aws-fake" number "0" should contain "running" as json field "_state"
