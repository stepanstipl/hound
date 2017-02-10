require 'active_record'

docker_namespace = namespace :docker do
  desc 'Load db schema if needed and run migrations'
  task :setup => [:environment, 'db:load_config'] do

    # Load shema id it doesn't exist
    Rake::Task['db:schema:load'].invoke unless ActiveRecord::SchemaMigration.table_exists?

    # Migrate
    Rake::Task['db:migrate'].invoke
  end
end
