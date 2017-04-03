@datacenter @datacenter_update
Feature: Update service with changed datacenter credentials

  Scenario: Non logged user listing
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "pwd"
    And The datacenter "update_datacenter" does not exist
    And The service "aws_test_update_dc" does not exist
    And I run ernest with "datacenter create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region --fake update_datacenter"
    And I start recording
    And I run ernest with "service apply internal/definitions/update_datacenter_aws_1.yml"
    And I stop recording
    And all "instance.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "tmp_secret_up_to_16_chars"
    And all "instance.create.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "tmp_secret_access_key"
    And I run ernest with "datacenter update aws --secret_access_key tmp_secret_access_key_2 --access_key_id tmp_secret_up_to_16_chars_2 update_datacenter"
    And I start recording
    When I run ernest with "service apply internal/definitions/update_datacenter_aws_2.yml"
    And I stop recording
    Then all "instance.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "tmp_secret_up_to_16_chars_2"
    And all "instance.create.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "tmp_secret_access_key_2"
