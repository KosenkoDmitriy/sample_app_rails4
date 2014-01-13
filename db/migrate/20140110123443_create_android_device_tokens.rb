class CreateAndroidDeviceTokens < ActiveRecord::Migration
  def change
    create_table :android_device_tokens do |t|
      t.string :token

      t.timestamps
    end
  end
end
