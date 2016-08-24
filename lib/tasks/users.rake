namespace :users do
  task update_encrypted_fields: :environment do
    User.find_each do |u|
      [:name, :cpf, :state, :city, :alias_name, :email].each do |attr|
        value = u.read_attribute(attr)

        u.send("#{attr}=".to_sym, value)
        # binding.pry if u.send("encrypted_#{attr}").blank?
      end

      # u.save
      binding.pry unless u.save(validate: false)
    end

    [:name, :cpf, :state, :city, :alias_name, :email].each do |attr|
      ActiveRecord::Migration.remove_column :users, attr
    end
  end

  task create_admin: :environment do
    u = User.new(email: 'contato@mudamos.org', name: 'Equipe Mudamos', is_admin: true, password: 'inventos123', password_confirmation: 'inventos123', picture: File.open("#{Rails.root}/app/assets/images/Mdomudamos-01-01.jpg", "r"))
    u.save
  end

  task set_master_admin_users: :environment do
    ['ariel@inventosdigitais.com.br', 'itsrio@itsrio.org'].each do |e|
      AdminUser.find_by_email(e).update_column(:admin_type, 1)
    end
  end
end
