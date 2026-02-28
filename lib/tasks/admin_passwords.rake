namespace :admin do
  desc "Migrate existing password hashes from Laravel (password) to Rails (password_digest)"
  task migrate_passwords: :environment do
    count = 0

    ActiveRecord::Base.connection.execute(<<~SQL).each do |row|
      SELECT id, password FROM cadatech_admins WHERE password_digest IS NULL AND password IS NOT NULL
    SQL
      digest = row["password"].sub(/\A\$2y\$/, "$2a$")
      ActiveRecord::Base.connection.execute(
        ActiveRecord::Base.sanitize_sql([
          "UPDATE cadatech_admins SET password_digest = ? WHERE id = ?", digest, row["id"]
        ])
      )
      count += 1
    end

    puts "Migrated #{count} password(s)."
  end
end
