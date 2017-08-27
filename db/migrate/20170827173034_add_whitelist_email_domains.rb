class AddWhitelistEmailDomains < ActiveRecord::Migration[5.0]
  def change
    create_table :whitelist_email_domains do |t|
      t.string :description
      t.timestamps
    end
  end
end
