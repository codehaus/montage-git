
def freshdb()
  config   = ActiveRecord::Base.configurations[RAILS_ENV]

  if ( RAILS_ENV == 'production' )
    puts "sorry, that's too dangerous" 
    return
  end

  database = config['database']
  user     = config['username']
  password = config['password']

  puts "database: #{database}"
  puts "user:     #{user}"
  puts "password: #{password}"

  puts `psql -h localhost -U #{user} -d template1 -c "drop database #{database}"`
  puts `psql -h localhost -d template1 -c "drop user #{user}"`
  puts `psql -h localhost -d template1 -c "create user #{user} createdb password '#{password}'"`
  puts `psql -h localhost -U #{user}  -d template1 -c "create database #{database}"`
end

desc 'Create a fresh db'
task :freshdb => [:environment] do |t|
  freshdb
end
