@datacenter @datacenter_update @datacenter_update_azure
Feature: Ernest azure datacenter update

  Scenario: Non logged azure datacenter creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "datacenter update azure"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Updating an existing azure datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "datacenter create azure --subscription_id subid --client_id cliid --client_secret secret --region westus --tenant_id tenid --environment public tmp_datacenter"
    And I run ernest with "datacenter list"
    And The output should contain "tmp_datacenter"
    When I run ernest with "datacenter update azure --subscription_id u_subid --client_id u_cliid --client_secret secret --tenant_id u_tenid --environment u_public tmp_datacenter"
    Then The output should contain "Datacenter tmp_datacenter successfully updated"
    And The azure datacenter "tmp_datacenter" credentials should be "u_subid", "u_cliid", "secret", "u_tenid" and "u_public"

  Scenario: Updating an unexisting azure datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "datacenter update azure --subscription_id u_subid --client_id u_cliid --client_secret secret --tenant_id u_tenid --environment u_public tmp_datacenter"
    Then The output should contain "Datacenter 'tmp_datacenter' does not exist, please specify a different datacenter name"
