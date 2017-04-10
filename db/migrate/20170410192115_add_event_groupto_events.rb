class AddEventGrouptoEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :event_group, :string
  end
end
