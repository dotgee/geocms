namespace :backend do

  desc "Delete public contexts created by non connected users"
  task :delete_public_contexts => :environment do
    Geocms::Context.where("folder_id IS NULL and created_at < ?", Time.now-2.days).delete_all
  end

end