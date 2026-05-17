ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::SQLite3Adapter.class_eval do
    def configure_connection
      super

      execute("PRAGMA journal_mode=WAL")
      execute("PRAGMA busy_timeout=5000")
      execute("PRAGMA foreign_keys=ON")

      if Rails.env.production?
        execute("PRAGMA synchronous=NORMAL")
        execute("PRAGMA cache_size=-8000")
        execute("PRAGMA mmap_size=268435456")
        execute("PRAGMA journal_size_limit=67108864")
        execute("PRAGMA temp_store=MEMORY")
      end
    end
  end
end
