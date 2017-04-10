class AddLimitToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :max_places, :integer, default: 0
  end
end
