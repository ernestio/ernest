@cli @apply_dry
Feature: Applying with dry option

  Scenario: Applying a basic azure service
    Given I setup ernest with target "https://ernest.local"
    And I setup a new service name
    When I'm logged in as "usr" / "secret123"
    And I apply the definition "azure1.yml" with dry option
    Then The output should contain "Applying this definition will:"
    And The output should contain "Create a resource group named rg2"
    And The output should contain "Create a virtual network named vn_test_2"
    And The output should contain "Create a virtual machine named vm_test_app-1"
    And The output should contain "Create a virtual machine named vm_test_app-2"
    And The output should contain "Create a subnet named sub_test_2"
    And The output should contain "Create a network interface named ni_test_2-1"
    And The output should contain "Create a network interface named ni_test_2-2"
    And The output should contain "Create a public ip named ni_test_2-1-config_2"
    And The output should contain "Create a public ip named ni_test_2-2-config_2"
    And The output should contain "Create a lb named lb1"
    And The output should contain "Create a security group named sg2"
    And The output should contain "Create a sql server named ernestserver02tom"
    And The output should contain "Create a sql database named mydb"
    And The output should contain "Create a sql firewall rule named rule1"
    And The output should contain "Create a storage account named safest12354tom2"
    And The output should contain "Create a storage container named scfestlatom2"
    And The output should contain "If you're agree with these changes please rerun apply without --dry option"
