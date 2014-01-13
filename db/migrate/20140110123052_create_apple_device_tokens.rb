class CreateAppleDeviceTokens < ActiveRecord::Migration
  def change
    create_table :apple_device_tokens do |t|
      t.string :token

      t.timestamps
    end
  end
end
