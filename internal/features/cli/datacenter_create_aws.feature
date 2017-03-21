@datacenter @datacenter_create @datacenter_create_aws
Feature: Ernest datacenter create

  Scenario: Non logged aws datacenter creation
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "datacenter create aws"
    Then The output should contain "You should specify the datacenter name"
    When I run ernest with "datacenter create aws tmp_datacenter"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged user aws datacenter creation
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "pwd"
    When I run ernest with "datacenter create aws"
    Then The output should contain "You should specify the datacenter name"
    When I run ernest with "datacenter create aws tmp_datacenter"
    Then The output should contain "Please, fix the error shown below to continue"
    And The output should contain "- Specify a valid secret access key with --secret_access_key flag"
    When I run ernest with "datacenter create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region tmp_datacenter"
    Then The output should contain "Datacenter 'tmp_datacenter' successfully created"
    When I run ernest with "datacenter list"
    Then The output should contain "tmp_datacenter"
    Then The output should contain "tmp_region"
    Then The output should contain "aws"

  Scenario: Adding an already existing aws datacenter
    Given I setup ernest with target "https://ernest.local"
    And the datacenter "tmp_datacenter" does not exist
    And I'm logged in as "usr" / "pwd"
    When I run ernest with "datacenter create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region tmp_datacenter"
    And I run ernest with "datacenter create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region tmp_datacenter"
    Then The output should contain "Datacenter 'tmp_datacenter' already exists, please specify a different name"


