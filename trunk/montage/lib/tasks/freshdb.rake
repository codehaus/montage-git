
def freshdb()
  config   = ActiveRecord::Base.configurations[RAILS_ENV]

  if ( RAILS_ENV == 'production' )
    puts "sorry, that's too dangerous" 
    return
  end

  database = config['database']
  user     = config['username']
  password = config['password']

  psql(user, password, 'localhost', 'template1', "drop database #{database}")
  psql(user, password, 'localhost', 'template1', "create database #{database}")
end

def psql(user, pass, host, database, command)
  ENV['PGUSER'] = user
  ENV['PGPASSWORD'] = pass
  ENV['PGHOST'] = host
  ENV['PGDATABASE'] = database
  puts "Running: #{command}"
  `psql -c "#{command}"`
end
  
  

desc 'Create a fresh db'
task :freshdb => [:environment] do |t|
  freshdb
end
