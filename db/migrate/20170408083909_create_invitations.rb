class CreateInvitations < ActiveRecord::Migration[5.0]
  def change
    create_table :invitations do |t|
      t.references :event, foreign_key: true
      t.string :unique_uri

      t.timestamps
    end
  end
end
