# Copyright (c) 2014 SUSE
# Licensed under the terms of the MIT license.

Feature: Test SP migration with sles11

  Scenario: migrate to scc
    Given file "/root/.mgr-sync" exists on server
    And file "/root/.mgr-sync" doesn't contain "mgrsync.user"
    And SCC feature is enabled
    When I execute mgr-sync "enable-scc"
    Then I want to get "SCC backend successfully migrated."
    And file "/var/lib/spacewalk/scc/migrated" exists on server

  Scenario: I want to add the needed channels
    When I execute mgr-sync "add channel sles11-sp4-pool-x86_64"
    And I execute mgr-sync "list channels --compact"
    Then I want to get "[I] sles11-sp4-pool-x86_64"
    Then I execute mgr-sync "add channel sles11-sp4-updates-x86_64"
    And I execute mgr-sync "list channels --compact"
    Then I want to get "[I] sles11-sp4-updates-x86_64"
    Then I execute mgr-sync "add channel sles11-sp4-suse-manager-tools-x86_64"
    And I execute mgr-sync "list channels --compact"
    Then I want to get "[I] sles11-sp4-suse-manager-tools-x86_64" 
    Then I wait till sp4 channels are synced

  Scenario: I prepare the virtual machine
    Then I shut off the vm
    And I revert the snapshot
    Then I turn on the vm

  Scenario: I create an activation key for sp migration key
    Given I am on the Systems page
    And I follow "Activation Keys" in the left menu
    And I follow "Create Key"
    When I enter "sp migration key" as "description"
    And I enter "sp_mig" as "key"
    And I check "monitoring_entitled"
    And I check "provisioning_entitled"
    And I select "SLES11-SP3-Pool for x86_64" from "selectedChannel"
    And I click on "Create Activation Key"
    And I follow "Child Channels"
    And I check "SLES11-SP3-SUSE-Manager-Tools x86_64"
    And I check "SLES11-SP3-Updates for x86_64"
    Then I click on "Update Key"   

  Scenario: I register the client
    When I register the client for sp migration
    Then I verify SP3 is installed

  Scenario: I perform the SP migration
    Given I am authorized
    When I follow "Systems"
    And I follow "sumapxc.suse.de"
    And I follow "Software" in the content area
    And I follow "SP Migration"
    And I click on "Schedule Migration"
    And I click on "Confirm"
    And I run rhn_check on the sp migration client
    Then I verify SP4 is installed