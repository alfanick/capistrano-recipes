namespace :assets do

  task :precompile, role: :app  do
    system "bundle exec rake assets:precompile"
  end

  before "deploy:update", "assets:precompile"

  task :rsync, role: :app  do
    puts "Rsyncing assets"
    hostname = find_servers_for_task(current_task).first
    system "rsync -arvz #{File.expand_path("../../../public/assets/", __FILE__)} #{hostname}:#{current_path}/public"
    puts "Rsync complete"
  end

  task :clean, role: :app  do
    system "bundle exec rake assets:clean"
  end

  task :update, role: :app do
    rsync
    clean
  end

  after "deploy:update", 'assets:update'
end