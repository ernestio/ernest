@vcloud @instance_only
Feature: Service apply

  Scenario: Applying an instance only service
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I start recording
    And I apply the definition "vcloud8.yml"
    And I stop recording
    Then an event "instance.create.vcloud-fake" should be called exactly "1" times
    And all "instance.create.vcloud-fake" messages should contain a field "_provider" with "vcloud-fake"
    And all "instance.create.vcloud-fake" messages should contain a field "vcloud_url" with "https://vcloud.net"
    And all "instance.create.vcloud-fake" messages should contain a field "datacenter_name" with "fakevcloud"
    And all "instance.create.vcloud-fake" messages should contain an encrypted field "datacenter_username" with "fakeuser@test"
    And all "instance.create.vcloud-fake" messages should contain an encrypted field "datacenter_password" with "test123"
    And all "instance.create.vcloud-fake" messages should contain a field "name" with "web-1"
    And all "instance.create.vcloud-fake" messages should contain a field "hostname" with "web-1"
    And all "instance.create.vcloud-fake" messages should contain a field "ip" with "10.1.0.11"
    And all "instance.create.vcloud-fake" messages should contain a field "network" with "web"
    And all "instance.create.vcloud-fake" messages should contain a field "cpus" with "1"
    And all "instance.create.vcloud-fake" messages should contain a field "ram" with "1024"
    And all "instance.create.vcloud-fake" messages should contain a field "reference_image" with "ubuntu-1404"
    And all "instance.create.vcloud-fake" messages should contain a field "reference_catalog" with "r3"
    And all "instance.create.vcloud-fake" messages should contain a field "_state" with "running"
