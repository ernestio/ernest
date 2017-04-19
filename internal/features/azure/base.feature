@azure @azure_base
Feature: Applying an azure based service

  Scenario: Applying a basic azure service
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I start recording
    And I apply the definition "azure1.yml"
    And I stop recording
    Then an event "resource_group.create.azure-fake" should be called exactly "1" times
    And all "resource_group.create.aws-fake" messages should contain a field "_provider" with "aws-fake"
    And all "resource_group.create.aws-fake" messages should contain a field "datacenter_region" with "fake"
    And all "resource_group.create.aws-fake" messages should contain a field "name" with "rg_1"
    And all "resource_group.create.aws-fake" messages should contain a field "location" with "westus"
    And all "resource_group.create.aws-fake" messages should contain an encrypted field "azure_client_id" with "cliid"
    And all "resource_group.create.aws-fake" messages should contain an encrypted field "azure_client_secret" with "clisec"
    And all "resource_group.create.aws-fake" messages should contain an encrypted field "azure_subscription_id" with "subid"
    And all "resource_group.create.aws-fake" messages should contain an encrypted field "azure_tenant_id" with "tenid"
    And all "resource_group.create.aws-fake" messages should contain an encrypted field "azure_environment" with "public"
    Then an event "network_interface.create.azure-fake" should be called exactly "1" times
    And all "network_interface.create.aws-fake" messages should contain a field "name" with "ni_test"
    And all "network_interface.create.aws-fake" messages should contain a field "resource_group_name" with "rg_1"
    And all "network_interface.create.aws-fake" messages should contain a field "network_security_group" with ""
    And all "network_interface.create.aws-fake" messages should contain a field "internal_dns_name_label" with "ni_test"

