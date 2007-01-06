
def psql()
  config   = ActiveRecord::Base.configurations[RAILS_ENV]
  cmd = "psql"
  ENV['PGUSER'] = config['username']
  ENV['PGDATABASE'] = config['database']
  ENV['PGPASSWORD'] = config['password']
  exec cmd
end

desc 'Launches a PSQL command for the current environment'
task :psql => [:environment] do |t|
  psql
end
