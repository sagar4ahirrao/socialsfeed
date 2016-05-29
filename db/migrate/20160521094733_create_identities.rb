class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, index: true
      t.string :secret
      t.string :provider
      t.string :profile_url
      t.string :accesstoken
      t.string :avatar_url
      t.string :refreshtoken
      t.string :uid

      t.timestamps
    end
  end
end
