namespace :db do
  namespace :sqlite do
    desc "Backup all SQLite databases to db/backups/"
    task backup: :environment do
      backup_dir = Rails.root.join("db/backups")
      FileUtils.mkdir_p(backup_dir)

      timestamp = Time.current.strftime("%Y%m%d%H%M%S")

      databases = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env).reject do |db_config|
        db_config.configuration_hash[:database].blank?
      end

      databases.each do |db_config|
        hash = db_config.configuration_hash
        db_path = Rails.root.join(hash[:database])
        next unless File.exist?(db_path)

        label = db_config.name
        filename = "#{label}_#{timestamp}.sqlite3"
        backup_path = backup_dir.join(filename)

        system("sqlite3", db_path.to_s, ".backup '#{backup_path}'")
        puts "Backed up #{label} to #{backup_path}"
      end

      puts "Backup complete."
    end
  end
end
