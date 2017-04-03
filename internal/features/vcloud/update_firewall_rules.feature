@vcloud @update_firewall_rules
Feature: Service apply

  Scenario: Updating router firewall rules
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I apply the definition "vcloud5.yml"
    And I start recording
    And I apply the definition "vcloud7.yml"
    And I stop recording
    Then an event "router.update.vcloud-fake" should be called exactly "1" times
    And all "router.update.vcloud-fake" messages should contain a field "_provider" with "vcloud-fake"
    And all "router.update.vcloud-fake" messages should contain a field "name" with "vse2"
    And all "router.update.vcloud-fake" messages should contain a field "vcloud_url" with "https://vcloud.net"
    And all "router.update.vcloud-fake" messages should contain a field "datacenter_name" with "fakevcloud"
    And all "router.update.vcloud-fake" messages should contain an encrypted field "datacenter_username" with "fakeuser@test"
    And all "router.update.vcloud-fake" messages should contain an encrypted field "datacenter_password" with "test123"
    And message "router.update.vcloud-fake" number "0" should contain "in_in_any" as json field "firewall_rules.0.name"
    And message "router.update.vcloud-fake" number "0" should contain "internal" as json field "firewall_rules.0.source_ip"
    And message "router.update.vcloud-fake" number "0" should contain "any" as json field "firewall_rules.0.source_port"
    And message "router.update.vcloud-fake" number "0" should contain "internal" as json field "firewall_rules.0.destination_ip"
    And message "router.update.vcloud-fake" number "0" should contain "any" as json field "firewall_rules.0.destination_port"
    And message "router.update.vcloud-fake" number "0" should contain "any" as json field "firewall_rules.0.protocol"
    And message "router.update.vcloud-fake" number "0" should contain "office2_in_22" as json field "firewall_rules.1.name"
    And message "router.update.vcloud-fake" number "0" should contain "172.18.143.3" as json field "firewall_rules.1.source_ip"
    And message "router.update.vcloud-fake" number "0" should contain "any" as json field "firewall_rules.1.source_port"
    And message "router.update.vcloud-fake" number "0" should contain "internal" as json field "firewall_rules.1.destination_ip"
    And message "router.update.vcloud-fake" number "0" should contain "22" as json field "firewall_rules.1.destination_port"
    And message "router.update.vcloud-fake" number "0" should contain "tcp" as json field "firewall_rules.1.protocol"
    And message "router.update.vcloud-fake" number "0" should contain "office1_in_22" as json field "firewall_rules.2.name"
    And message "router.update.vcloud-fake" number "0" should contain "172.17.240.0/24" as json field "firewall_rules.2.source_ip"
    And message "router.update.vcloud-fake" number "0" should contain "any" as json field "firewall_rules.2.source_port"
    And message "router.update.vcloud-fake" number "0" should contain "internal" as json field "firewall_rules.2.destination_ip"
    And message "router.update.vcloud-fake" number "0" should contain "22" as json field "firewall_rules.2.destination_port"
    And message "router.update.vcloud-fake" number "0" should contain "tcp" as json field "firewall_rules.2.protocol"
    And message "router.update.vcloud-fake" number "0" should contain "home_in_22" as json field "firewall_rules.3.name"
    And message "router.update.vcloud-fake" number "0" should contain "172.19.186.30" as json field "firewall_rules.3.source_ip"
    And message "router.update.vcloud-fake" number "0" should contain "any" as json field "firewall_rules.3.source_port"
    And message "router.update.vcloud-fake" number "0" should contain "internal" as json field "firewall_rules.3.destination_ip"
    And message "router.update.vcloud-fake" number "0" should contain "8080" as json field "firewall_rules.3.destination_port"
    And message "router.update.vcloud-fake" number "0" should contain "tcp" as json field "firewall_rules.3.protocol"
