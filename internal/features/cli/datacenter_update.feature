@datacenter @datacenter_update
Feature: Ernest datacenter create

  Scenario: Non logged vcloud datacenter creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "datacenter update vcloud"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Updating an existing vcloud datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "pwd"
    And I run ernest with "datacenter create vcloud --user usr --password xxxx --org MY-ORG-NAME --vse-url http://vse.url --vcloud-url https://myernest.com --public-network MY-PUBLIC-NETWORK tmp_datacenter"
    And I run ernest with "datacenter list"
    And The output should contain "tmp_datacenter"
    When I run ernest with "datacenter update vcloud tmp_datacenter --user me --org MY-NEW-ORG --password secret"
    Then The output should contain "Datacenter tmp_datacenter successfully updated"

  Scenario: Updating an unexisting vcloud datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "pwd"
    When I run ernest with "datacenter update vcloud tmp_datacenter --user me --org MY-NEW-ORG --password secret"
    Then The output should contain "Datacenter 'tmp_datacenter' does not exist, please specify a different datacenter name"

  Scenario: Non logged aws datacenter creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "datacenter update aws"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Updating an existing aws datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "pwd"
    And I run ernest with "datacenter create aws --secret_access_key tmp_secret_access_key_up_to_16_chars --access_key_id tmp_secret_up_to_16_chars --region tmp_region tmp_datacenter"
    And I run ernest with "datacenter list"
    And The output should contain "tmp_datacenter"
    When I run ernest with "datacenter update aws tmp_datacenter --secret_access_key tmp_secret_access_key_up_to_16_chars --access_key_id tmp_secret_up_to_16_chars"
    Then The output should contain "Datacenter tmp_datacenter successfully updated"
    And The aws datacenter "tmp_datacenter" credentials should be "tmp_secret_up_to_16_chars" and "tmp_secret_access_key_up_to_16_chars"

  Scenario: Updating an unexisting aws datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "pwd"
    When I run ernest with "datacenter update aws tmp_datacenter --secret_access_key very_large_aws_token_string --access_key_id secret"
    Then The output should contain "Datacenter 'tmp_datacenter' does not exist, please specify a different datacenter name"

