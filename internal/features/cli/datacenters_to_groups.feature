@group @datacenters_to_groups
Feature: Ernest datacenters to groups

  Scenario: Non logged - datacenter to group
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "group add-datacenter"
    Then The output should contain "You should specify the datacenter name and group name"
    When I run ernest with "group add-datacenter tmp_datacenter"
    Then The output should contain "You should specify the group name"
    When I run ernest with "group add-datacenter tmp_datacenter tmp_group"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Plain datacenter - datacenter to group
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "pwd"
    When I run ernest with "group add-datacenter"
    Then The output should contain "You should specify the datacenter name and group name"
    When I run ernest with "group add-datacenter tmp_datacenter"
    Then The output should contain "You should specify the group name"
    When I run ernest with "group add-datacenter tmp_datacenter tmp_group"
    Then The output should contain "You don't have permissions to perform this action"

  Scenario: Admin datacenter - datacenter to group
    Given I setup ernest with target "https://ernest.local"
    And the group "tmp_group" exists
    And the datacenter "tmp_datacenter" exists
    And I'm logged in as "ci_admin" / "pwd"
    When I run ernest with "group add-datacenter"
    Then The output should contain "You should specify the datacenter name and group name"
    When I run ernest with "group add-datacenter tmp_datacenter"
    Then The output should contain "You should specify the group name"
    When I run ernest with "group add-datacenter tmp_datacenter tmp_group"
    Then The output should contain "Datacenter 'tmp_datacenter' is now assigned to group 'tmp_group'"
    When I run ernest with "datacenter list"
    Then The output datacenters table should contain "tmp_datacenter" assigned to "tmp_group" group

  Scenario: Already assigned datacenter
    Given I setup ernest with target "https://ernest.local"
    And the group "tmp_group" exists
    And the datacenter "tmp_datacenter" exists
    And I'm logged in as "ci_admin" / "pwd"
    And I run ernest with "group add-datacenter tmp_datacenter tmp_group"
    When I run ernest with "group add-datacenter tmp_datacenter tmp_group"
    Then The output should contain "Datacenter 'tmp_datacenter' already belongs to 'tmp_group' group"

  Scenario: Unexisting group
    Given I setup ernest with target "https://ernest.local"
    And the group "tmp_group" does not exist
    And the datacenter "tmp_datacenter" exists
    And I'm logged in as "ci_admin" / "pwd"
    When I run ernest with "group add-datacenter tmp_datacenter tmp_group"
    Then The output should contain "Group 'tmp_group' does not exist"

  Scenario: Unexisting datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And the group "tmp_group" exists
    And I'm logged in as "ci_admin" / "pwd"
    When I run ernest with "group add-datacenter tmp_datacenter tmp_group"
    Then The output should contain "Datacenter 'tmp_datacenter' does not exist"

  Scenario: Admin datacenter - remove datacenter from  group
    Given I setup ernest with target "https://ernest.local"
    And the group "tmp_group" exists
    And the datacenter "tmp_datacenter" exists
    And I'm logged in as "ci_admin" / "pwd"
    And I run ernest with "group add-datacenter tmp_datacenter tmp_group"
    When I run ernest with "group remove-datacenter"
    Then The output should contain "You should specify the datacenter name and group name"
    When I run ernest with "group remove-datacenter tmp_datacenter"
    Then The output should contain "You should specify the group name"
    When I run ernest with "group remove-datacenter tmp_datacenter tmp_group"
    Then The output should contain "Datacenter 'tmp_datacenter' is not assigned anymore to group 'tmp_group'"
    When I run ernest with "datacenter list"
    Then The output datacenters table should contain "tmp_datacenter" assigned to " " group
