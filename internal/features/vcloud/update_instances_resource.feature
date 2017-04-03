@vcloud @update_instances_resource
Feature: Service apply

  Scenario: Update existing instance ram and cpu
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I apply the definition "vcloud4.yml"
    And I start recording
    And I apply the definition "vcloud5.yml"
    And I stop recording
    Then an event "instance.update.vcloud-fake" should be called exactly "2" times
    And all "instance.update.vcloud-fake" messages should contain a field "_provider" with "vcloud-fake"
    And all "instance.update.vcloud-fake" messages should contain a field "vcloud_url" with "https://vcloud.net"
    And all "instance.update.vcloud-fake" messages should contain a field "datacenter_name" with "fakevcloud"
    And all "instance.update.vcloud-fake" messages should contain an encrypted field "datacenter_username" with "fakeuser@test"
    And all "instance.update.vcloud-fake" messages should contain an encrypted field "datacenter_password" with "test123"
    And message "instance.update.vcloud-fake" number "0" should contain "web-1" as json field "name"
    And message "instance.update.vcloud-fake" number "0" should contain "web-1" as json field "hostname"
    And message "instance.update.vcloud-fake" number "0" should contain "10.1.0.11" as json field "ip"
    And message "instance.update.vcloud-fake" number "0" should contain "web" as json field "network"
    And message "instance.update.vcloud-fake" number "0" should contain "4" as json field "cpus"
    And message "instance.update.vcloud-fake" number "0" should contain "8192" as json field "ram"
    And message "instance.update.vcloud-fake" number "0" should contain "ubuntu-1404" as json field "reference_image"
    And message "instance.update.vcloud-fake" number "0" should contain "r3" as json field "reference_catalog"
    And message "instance.update.vcloud-fake" number "1" should contain "web-2" as json field "name"
    And message "instance.update.vcloud-fake" number "1" should contain "web-2" as json field "hostname"
    And message "instance.update.vcloud-fake" number "1" should contain "10.1.0.12" as json field "ip"
    And message "instance.update.vcloud-fake" number "1" should contain "web" as json field "network"
    And message "instance.update.vcloud-fake" number "1" should contain "4" as json field "cpus"
    And message "instance.update.vcloud-fake" number "1" should contain "8192" as json field "ram"
    And message "instance.update.vcloud-fake" number "1" should contain "ubuntu-1404" as json field "reference_image"
    And message "instance.update.vcloud-fake" number "1" should contain "r3" as json field "reference_catalog"
