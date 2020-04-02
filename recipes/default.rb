#
# Cookbook:: trusted_ca
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
include_recipe 'trusted_certificate::default'

node['trusted_ca']['add'].each do |name|
  item = begin
          search(node['trusted_ca']['data_bag'].to_sym, "id:#{name}").first
        rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
          nil
        end
  if item
    trusted_certificate name do
      action :create
      content item['cert']
    end
  end
end

node['trusted_ca']['remove'].each do |name|
  trusted_certificate name do
    action :delete
  end
end
