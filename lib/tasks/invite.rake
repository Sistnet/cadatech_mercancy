namespace :invite do
  desc "Gerar token(s) de convite para /register"
  task :generate, [ :count, :email, :hours, :notes ] => :environment do |_, args|
    count = (args[:count] || 1).to_i
    email = args[:email].presence
    hours = (args[:hours] || ENV.fetch("REGISTER_INVITE_EXPIRY_HOURS", 72)).to_i
    notes = args[:notes]
    base_url = ENV.fetch("APP_URL", "https://partner-hml.mercancy.com.br")

    count.times do
      invite = RegisterInvite.create!(
        email: email,
        expires_at: hours.hours.from_now,
        created_by: "rake-cli",
        notes: notes
      )

      puts "ID:      #{invite.id}"
      puts "Token:   #{invite.token[0..15]}..."
      puts "URL:     #{base_url}/register?token=#{invite.token}"
      puts "Expira:  #{invite.expires_at.strftime('%Y-%m-%d %H:%M:%S')}"
      puts "---"
    end
  end
end
