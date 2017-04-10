class ChangeStatusHandling < ActiveRecord::Migration[5.0]
  def change
    remove_column :invitations, :accepted
    remove_column :invitations, :declined
    remove_column :invitations, :tentative
    add_column    :invitations, :status, :integer, default: 0
  end
end
