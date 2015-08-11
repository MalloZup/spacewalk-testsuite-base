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
