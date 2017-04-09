class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :place
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
