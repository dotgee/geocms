namespace :geocms do
  namespace :create do
    desc "creates roles users"
    task seed_roles: :environment do
      puts "###########################"
      puts "Create user roles :"
      puts "###########################"
      puts ""
      Geocms::Role.find_or_create_by(name: "admin_instance")
      puts "Role admin_instance created"

      Geocms::Role.find_or_create_by(name: "admin_data")
      puts "Role admin_data created"

      Geocms::Role.find_or_create_by(name: "user")
      puts "Role user created"

      Geocms::Role.find_or_create_by(name: "admin")
      puts "Role admin created"
    end
  end
end
