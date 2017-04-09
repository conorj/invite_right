class AddStatusToInvitation < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :accepted, :integer, default: 0
    add_column :invitations, :declined, :integer, default: 0
    add_column :invitations, :tentative, :integer, default: 0
  end
end
