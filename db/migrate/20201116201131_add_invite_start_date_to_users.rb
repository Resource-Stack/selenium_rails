class AddInviteStartDateToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :invite_start_date, :datetime
  end
end
