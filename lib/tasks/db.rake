def say(mess); puts mess; end

namespace :db do
  desc 'Drop, create and migrate the database.'
  task :reinstall do
    ['uploads', 'public/uploads', 'public/packs'].each do |path|
      cmd = "rm -fr #{path}"
      puts cmd
      `#{cmd}`
    end
    Rake::Task['db:drop'].invoke
    Rake::Task['db:install'].invoke
    if Rails.env.development? || Rails.env.test?
      Rake::Task['db:seed'].invoke
    end
  end

  desc 'Creates and populates the initial database for a new project.'
  task install: ['tmp:create', 'tmp:cache:clear', 'assets:clobber', 'db:create', 'db:migrate']
end
