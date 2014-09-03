namespace :backend do

  desc "Delete public contexts created by non connected users"
  task :delete_public_contexts => :environment do
    Geocms::Context.where("folder_id IS NULL and created_at < ?", Time.now-2.days).delete_all
  end

  desc "Add folder to users without one"
  task :add_folder_to_users => :environment do
    Geocms::User.all.select { |u| u.folders.count == 0 }.each { |u| u.set_folder && u.save }
  end
end