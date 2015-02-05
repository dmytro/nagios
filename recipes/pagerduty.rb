#
# Cookbook Name:: coiney
# Recipe:: pagerduty
#
# Copyright 2014, Dmytro Kovalov
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
# Nagios to Pager integration, instead of standard nagios::pagerduty, which is broken.
#
install_file = "#{Chef::Config[:file_cache_path]}/everpager.tar.gz"
install_dir = "#{Chef::Config[:file_cache_path]}/everpager"

remote_file install_file do
  source "https://github.com/gerirgaudi/everpager/archive/master.tar.gz"
end

directory install_dir

execute :install do
  command "cd #{install_dir} && tar --strip-components=1 -xzf #{ install_file } && gem build everpager.gemspec && gem install everpager-*.gem"
  not_if "gem list evernote --local | grep evernote > /dev/null 2>&1 "
end

nagios_conf 'pagerduty' do
  variables rvm_bindir: node['coiney']['rvm']['binpath']
end
