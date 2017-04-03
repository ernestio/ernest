@aws @delete_elb_and_s3
Feature: Service apply

  Scenario: delete an elb and an s3
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "pwd"
    And I apply the definition "aws14.yml"
    And I start recording
    And I apply the definition "aws15.yml"
    And I stop recording
    Then an event "elb.delete.aws-fake" should be called exactly "1" times
    And all "elb.delete.aws-fake" messages should contain a field "_provider" with "aws-fake"
    And all "elb.delete.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "up_to_16_characters_secret"
    And all "elb.delete.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "fake_up_to_16_characters"
    And all "elb.delete.aws-fake" messages should contain a field "datacenter_region" with "fake"
    And all "elb.delete.aws-fake" messages should contain a field "name" with "elb-1"
    And message "elb.delete.aws-fake" number "0" should contain "web-1" as json field "instance_names.0"
    And message "elb.delete.aws-fake" number "0" should contain "foo" as json field "security_group_aws_ids.0"
    And message "elb.delete.aws-fake" number "0" should contain "80" as json field "listeners.0.from_port"
    And message "elb.delete.aws-fake" number "0" should contain "80" as json field "listeners.0.to_port"
    And message "elb.delete.aws-fake" number "0" should contain "HTTP" as json field "listeners.0.protocol"
    And message "elb.delete.aws-fake" number "0" should have an empty json field "listeners.0.ssl_cert"
    And message "elb.delete.aws-fake" number "0" should contain "foo" as json field "security_group_aws_ids.0"
    And message "elb.delete.aws-fake" number "0" should contain "443" as json field "listeners.1.from_port"
    And message "elb.delete.aws-fake" number "0" should contain "443" as json field "listeners.1.to_port"
    And message "elb.delete.aws-fake" number "0" should contain "HTTPS" as json field "listeners.1.protocol"
    And message "elb.delete.aws-fake" number "0" should contain "foo" as json field "listeners.1.ssl_cert"
    Then an event "s3.delete.aws-fake" should be called exactly "1" times
    And all "s3.delete.aws-fake" messages should contain a field "_provider" with "aws-fake"
    And all "s3.delete.aws-fake" messages should contain an encrypted field "aws_access_key_id" with "up_to_16_characters_secret"
    And all "s3.delete.aws-fake" messages should contain an encrypted field "aws_secret_access_key" with "fake_up_to_16_characters"
    And all "s3.delete.aws-fake" messages should contain a field "bucket_location" with "eu-west-1"
    And message "s3.delete.aws-fake" number "0" should contain "foo@r3labs.io" as json field "grantees.0.id"
    And message "s3.delete.aws-fake" number "0" should contain "emailaddress" as json field "grantees.0.type"
    And message "s3.delete.aws-fake" number "0" should contain "FULL_CONTROL" as json field "grantees.0.permissions"
    And message "s3.delete.aws-fake" number "0" should contain "bar@r3labs.io" as json field "grantees.1.id"
    And message "s3.delete.aws-fake" number "0" should contain "emailaddress" as json field "grantees.1.type"
    And message "s3.delete.aws-fake" number "0" should contain "WRITE" as json field "grantees.1.permissions"
