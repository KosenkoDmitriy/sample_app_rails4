class CreateRegistrationIds < ActiveRecord::Migration
  def change
    create_table :registration_ids do |t|
      t.string :reg_id

      t.timestamps
    end
  end
end
