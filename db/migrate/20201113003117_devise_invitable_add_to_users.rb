# frozen_string_literal: true

class DeviseInvitableAddToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :invitation_token, :string, limit: nil
    add_column :users, :invitation_created_at, :datetime
    add_column :users, :invitation_sent_at, :datetime
    add_column :users, :invitation_accepted_at, :datetime
    add_column :users, :invitation_limit, :integer
    add_column :users, :invited_by_id, :integer
    add_column :users, :invited_by_type, :string
    add_index :users, :invitation_token, unique: true
  end
end
