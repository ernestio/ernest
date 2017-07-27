@project @project_update
Feature: Update environment with changed project credentials

  Scenario: Non logged user listing
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The project "update_project" does not exist
    And The environment "aws_test_update_dc" does not exist
    And I run ernest with "project create aws --secret_access_key tmp_secret_access_key --access_key_id tmp_secret_up_to_16_chars --region tmp_region --fake update_project"
    And I start recording
    And I run ernest with "environment apply internal/definitions/update_project_aws_1.yml"
    And I stop recording
    And all "instance.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "tmp_secret_up_to_16_chars"
    And all "instance.create.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "tmp_secret_access_key"
    And I run ernest with "project update aws --secret_access_key tmp_secret_access_key_2 --access_key_id tmp_secret_up_to_16_chars_2 update_project"
    And I start recording
    When I run ernest with "environment apply internal/definitions/update_project_aws_2.yml"
    And I stop recording
    Then all "instance.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "tmp_secret_up_to_16_chars_2"
    And all "instance.create.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "tmp_secret_access_key_2"
