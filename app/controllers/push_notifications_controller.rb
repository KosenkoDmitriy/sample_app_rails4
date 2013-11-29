class PushNotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  def index
    @hello = "hello from controller"
    @reg_ids = RegistrationId.uniq.pluck(:reg_id)

  end
  
  def verify
    send_file "app/assets/googlecfc212ce9fce9cf8.html", :type=>"application/zip"
  end
  
  def google
#    app = Rapns::Gcm::App.new
#    app.name = "name.adec.android.shop"
#    app.auth_key = "AIzaSyDDBzIQOhaN5iXGjPeIBnIJNWP2t0QUz8E" #"AIzaSyBjHSYGd3ufpk0v76o5v-Bu-MdmrjhLVtQ"
#    app.connections = 1
#    app.save!
#    request.body;
    @user = RegistrationId.new # (reg_id: "sadfsaf131fasd" )
    @user.reg_id = params[:id]
    #if @user.save
      # Handle a successful save.
    @user.save()
    
    @reg_ids = RegistrationId.uniq.pluck(:reg_id)
    
    n = Rapns::Gcm::Notification.new
    n.app = Rapns::Gcm::App.find_by_name("name.adec.android.shop")
    n.registration_ids = @reg_ids #[ params[:id],  ] # ["1","2","3"] #["AIzaSyBjHSYGd3ufpk0v76o5v-Bu-MdmrjhLVtQ"] #//
    n.data = {:message => "hi adec llc!"}
    n.save!
  end
  
  def apple
    #TODO: generate SSL certificate https://github.com/ileitch/rapns/wiki/Generating-Certificates
    app = Rapns::Apns::App.new
    app.name = "ios_app"
    app.certificate = File.read("config/database.yml") # File.read("/path/to/sandbox.pem")
    app.environment = "sandbox" # APNs environment.
    app.password = "certificate password"
    app.connections = 1
    app.save()
    n = Rapns::Apns::Notification.new
    n.app = Rapns::Apns::App.find_by_name("ios_app")
    n.device_token = "..."
    n.alert = "hi mom!"
    n.attributes_for_device = {:foo => :bar}
    n.save()
  end
 
end
