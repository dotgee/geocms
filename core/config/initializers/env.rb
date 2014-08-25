Rails.application.config.before_configuration do
  env_file = File.expand_path('../../local_env.yml', __FILE__)
  YAML.load(File.open(env_file)).each do |key, value|
    ENV[key.to_s] = value
  end if File.exists?(env_file)
end