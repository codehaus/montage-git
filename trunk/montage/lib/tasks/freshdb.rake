def db_command(user, pass, host, database, command)
  ENV['PGUSER'] = user
  ENV['PGPASSWORD'] = pass
  ENV['PGHOST'] = host
  ENV['PGDATABASE'] = database
  puts "Running: #{command}"
  `psql -c "#{command}"`
end

def freshdb()
  config   = ActiveRecord::Base.configurations[RAILS_ENV]

  if ( RAILS_ENV == 'production' )
    puts "sorry, that's too dangerous" 
    return
  end

  database = config['database']
  user     = config['username']
  password = config['password']

  db_command(user, password, 'localhost', 'template1', "drop database #{database}")
  db_command(user, password, 'localhost', 'template1', "create database #{database}")
end

desc 'Create a fresh db'
task :freshdb => [:environment] do |t|
  freshdb
end
