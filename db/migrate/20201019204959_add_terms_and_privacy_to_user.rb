class AddTermsAndPrivacyToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :terms_acknowledged, :boolean, :default => false
    add_column :users, :privacy_acknowledged, :boolean, :default => false
  end
end
