@cli @env_credentials
Feature: Environment credentials

  Scenario: Override project credentials at an environment level with create
    Given I setup ernest with target "https://ernest.local"
    And I setup a new environment name
    And I'm logged in as "usr" / "secret123"
    And I run ernest with "environment create fakeaws $(name) --secret_access_key tmp_secret_access_key_2 --access_key_id tmp_secret_up_to_16_chars_2"
    And I start recording
    And I apply the definition "aws1.yml"
    And I stop recording
    Then all "instance.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "tmp_secret_up_to_16_chars_2"
    And all "instance.create.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "tmp_secret_access_key_2"

  Scenario: Override project credentials at an environment level with create
    Given I setup ernest with target "https://ernest.local"
    And I setup a new environment name
    And I'm logged in as "usr" / "secret123"
    And I run ernest with "environment create fakeaws $(name)"
    And I run ernest with "environment update fakeaws $(name) --secret_access_key tmp_secret_access_key_2 --access_key_id tmp_secret_up_to_16_chars_2"
    And I start recording
    And I apply the definition "aws1.yml"
    And I stop recording
    Then all "instance.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "tmp_secret_up_to_16_chars_2"

  Scenario: Override project credentials at an environment level with apply
    Given I setup ernest with target "https://ernest.local"
    And I setup a new environment name
    And I'm logged in as "usr" / "secret123"
    And I start recording
    And I apply "aws1.yml" with "--secret_access_key tmp_secret_access_key_2 --access_key_id tmp_secret_up_to_16_chars_2"
    And I stop recording
    Then all "instance.create.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "tmp_secret_up_to_16_chars_2"
    And all "instance.create.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "tmp_secret_access_key_2"

  Scenario: Override environment credentials with update
    Given I setup ernest with target "https://ernest.local"
    And The environment "tmp_cred_update" does not exist
    And I setup a new environment name "tmp_cred_update"
    And I'm logged in as "usr" / "secret123"
    And I apply the definition "aws8.yml"
    When I run ernest with "env update fakeaws tmp_cred_update --secret_access_key tmp_secret_access_key_upd --access_key_id tmp_secret_up_to_16_chars_upd"
    And I start recording
    And I apply the definition "aws9.yml"
    And I stop recording
    Then all "network.delete.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "tmp_secret_up_to_16_chars_upd"
    And all "network.delete.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "tmp_secret_access_key_upd"
    And I start recording
    And I run ernest with "env delete fakeaws tmp_cred_update"
    And I stop recording
    Then all "instance.delete.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "tmp_secret_up_to_16_chars_upd"
    And all "instance.delete.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "tmp_secret_access_key_upd"


