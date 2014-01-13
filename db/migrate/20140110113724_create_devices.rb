class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :token
      t.string :operating_system
      t.string :uid

      t.timestamps
    end
  end
end
