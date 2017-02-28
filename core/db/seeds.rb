puts "###########################"
puts "Create user roles :"
puts "###########################"
puts ""
Geocms::Role.find_or_create_by!(name: "admin_instance")
puts "admin_instance created"

Geocms::Role.find_or_create_by!(name: "admin_data")
puts "admin_data created"

Geocms::Role.find_or_create_by!(name: "user")
puts "Role user created"

account = Geocms::Account.new(default: true)
puts "Create default account :"
puts "Account name (demo):"
account.name = STDIN.gets.chomp || "demo" 

puts "Account subdomain (demo):"
account.subdomain = STDIN.gets.chomp || "demo"
account.save
puts "Account created"

user = Geocms::User.new


puts "###########################"
puts "Create default admin user :"
puts "###########################"
puts ""
puts "Admin email (demo@geocms.com):"
user.email = STDIN.gets.chomp || "demo@geocms.com"

puts "Admin username (geocms):"
user.email = STDIN.gets.chomp || "geocms"

puts "Admin password (geocms_demo):"
user.password = STDIN.gets.chomp || "geocms_demo"

user.accounts << account
user.add_role :admin
user.save
puts "User created"

