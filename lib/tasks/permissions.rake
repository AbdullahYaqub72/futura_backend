# bundle exec rake permissions:sync
namespace :permissions do
  desc "Sync controller actions to permissions table"
  task sync: :environment do
    puts "Syncing permissions..."

    Rails.application.eager_load! # Load all controllers

    ApplicationController.descendants.each do |controller|
      controller_name = controller.name.gsub("Controller", "").underscore

      controller.public_instance_methods(false).each do |action|
        permission_name = "#{controller_name}##{action}"
        Permission.find_or_create_by(name: permission_name)
        puts "Synced: #{permission_name}"
      end
    end

    puts "Permission sync complete."
  end
end