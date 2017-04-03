@vcloud @remove_and_dettach_network
Feature: Service apply

  Scenario: Remove a network and dettach an existing instance
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I apply the definition "vcloud3.yml"
    And I start recording
    And I apply the definition "vcloud2.yml"
    And I stop recording
    Then an event "instance.delete.vcloud-fake" should be called exactly "1" times
    And all "instance.delete.vcloud-fake" messages should contain a field "_provider" with "vcloud-fake"
    And all "instance.delete.vcloud-fake" messages should contain a field "vcloud_url" with "https://vcloud.net"
    And all "instance.delete.vcloud-fake" messages should contain a field "datacenter_name" with "fakevcloud"
    And all "instance.delete.vcloud-fake" messages should contain an encrypted field "datacenter_username" with "fakeuser@test"
    And all "instance.delete.vcloud-fake" messages should contain an encrypted field "datacenter_password" with "test123"
    And all "instance.delete.vcloud-fake" messages should contain a field "name" with "web-1"
    And all "instance.delete.vcloud-fake" messages should contain a field "hostname" with "web-1"
    And all "instance.delete.vcloud-fake" messages should contain a field "ip" with "10.1.0.11"
    And all "instance.delete.vcloud-fake" messages should contain a field "network" with "web"
    And all "instance.delete.vcloud-fake" messages should contain a field "cpus" with "1"
    And all "instance.delete.vcloud-fake" messages should contain a field "ram" with "1024"
    And all "instance.delete.vcloud-fake" messages should contain a field "reference_image" with "ubuntu-1404"
    And all "instance.delete.vcloud-fake" messages should contain a field "reference_catalog" with "r3"
    Then an event "network.delete.vcloud-fake" should be called exactly "1" times
    And all "network.delete.vcloud-fake" messages should contain a field "_provider" with "vcloud-fake"
    And all "network.delete.vcloud-fake" messages should contain a field "range" with "10.1.0.0/24"
    And all "network.delete.vcloud-fake" messages should contain a field "vcloud_url" with "https://vcloud.net"
    And all "network.delete.vcloud-fake" messages should contain a field "datacenter_name" with "fakevcloud"
    And all "network.delete.vcloud-fake" messages should contain an encrypted field "datacenter_username" with "fakeuser@test"
    And all "network.delete.vcloud-fake" messages should contain an encrypted field "datacenter_password" with "test123"
