@vcloud @increase_instances_count
Feature: Service apply

  Scenario: Increasing instance count
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I apply the definition "vcloud3.yml"
    And I start recording
    And I apply the definition "vcloud4.yml"
    And I stop recording
    Then an event "instance.create.vcloud-fake" should be called exactly "1" times
    And all "instance.create.vcloud-fake" messages should contain a field "_provider" with "vcloud-fake"
    And all "instance.create.vcloud-fake" messages should contain a field "vcloud_url" with "https://vcloud.net"
    And all "instance.create.vcloud-fake" messages should contain a field "datacenter_name" with "fakevcloud"
    And all "instance.create.vcloud-fake" messages should contain an encrypted field "datacenter_username" with "fakeuser@test"
    And all "instance.create.vcloud-fake" messages should contain an encrypted field "datacenter_password" with "test123"
    And all "instance.create.vcloud-fake" messages should contain a field "name" with "web-2"
    And all "instance.create.vcloud-fake" messages should contain a field "hostname" with "web-2"
    And all "instance.create.vcloud-fake" messages should contain a field "ip" with "10.1.0.12"
    And all "instance.create.vcloud-fake" messages should contain a field "network" with "web"
    And all "instance.create.vcloud-fake" messages should contain a field "cpus" with "1"
    And all "instance.create.vcloud-fake" messages should contain a field "ram" with "1024"
    And all "instance.create.vcloud-fake" messages should contain a field "reference_image" with "ubuntu-1404"
    And all "instance.create.vcloud-fake" messages should contain a field "reference_catalog" with "r3"
