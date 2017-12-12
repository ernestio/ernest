@environment @environment_apply
Feature: Environment apply

  Scenario: Non logged environment apply
    Given I setup ernest with target "https://ernest.local"
    And I logout
    When I run ernest with "environment apply"
    Then The output should contain "Please provide required parameters:"
    And The output should contain "$ ernest env apply <file.yml>"
    When I run ernest with "environment apply definitions/aws1.yml"
    Then The output should contain "You're not allowed to perform this action, please log in"

  Scenario: Logged environment apply errors
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    When I run ernest with "environment apply"
    Then The output should contain "Please provide required parameters:"
    And The output should contain "$ ernest env apply <file.yml>"
    When I run ernest with "environment apply internal/definitions/unexisting_dc.yml"
    Then The output should contain "Specified project does not exist"

  Scenario: Logged environment apply
    Given I setup ernest with target "https://ernest.local"
    And I setup a new environment name "aws_test_environment"
    And I'm logged in as "usr" / "secret123"
    And The environment "fakeaws/aws_test_environment" does not exist
    And I apply the definition "aws1.yml"
    Then The output should contain "Status: Applied"

  Scenario: Logged environment apply with internal file references
    Given I setup ernest with target "https://ernest.local"
    And I'm logged in as "usr" / "secret123"
    And The environment "fakeaws/aws_test_environment" does not exist
    When I apply the definition "aws-template1-unexisting.yml"
    Then The output should contain "Can't access referenced file"
