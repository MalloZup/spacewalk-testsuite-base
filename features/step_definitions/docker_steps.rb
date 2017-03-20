# Copyright (c) 2017 Suse Linux
# Licensed under the terms of the MIT license.

require "xmlrpc/client"
require 'time'
# container_operations
cont_op = XMLRPCImageTest.new(ENV['TESTHOST'])
sysrpc = XMLRPCSystemTest.new(ENV['TESTHOST'])

cont_op.login('admin', 'admin')

And(/^I select sle-minion hostname in Build Host$/) do
  select($minion_fullhostname, :from => 'host')
end

And(/^I navigate to images webpage$/) do
  visit("https://#{$server_fullhostname}/rhn/manager/cm/images")
end

And(/^I navigate to images build webpage$/) do
  visit("https://#{$server_fullhostname}/rhn/manager/cm/build")
end
And(/^I schedule the build of image "([^"]*)" via xmlrpc-call$/) do |image|
  sysrpc.login('admin', 'admin')
  systems = sysrpc.listSystems
  refute_nil(systems)
  hostname = $minion_fullhostname
  minion_id = systems
              .select { |s| s['name'] == hostname }
              .map { |s| s['id'] }.first

  refute_nil(minion_id, "Minion #{hostname} is not yet registered?")
  # empty by default
  version_build = ''
  date_build = Time.now.utc.iso8601
  build_hostid = minion_id
  cont_op.scheduleImageBuild(image, version_build, build_hostid, date_build)
end
