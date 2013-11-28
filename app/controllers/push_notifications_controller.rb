class PushNotificationsController < ApplicationController
  
  def index
    @hello = "hello from controller"
  end
  
  def google
#    app = Rapns::Gcm::App.new
#    app.name = "name.adec.shop"
#    app.auth_key = "AIzaSyBjHSYGd3ufpk0v76o5v-Bu-MdmrjhLVtQ"
#    app.connections = 1
#    app.save!
    
    n = Rapns::Gcm::Notification.new
    n.app = Rapns::Gcm::App.find_by_name("name.adec.android.shop")
    n.registration_ids = ["1","2","3"] #["AIzaSyBjHSYGd3ufpk0v76o5v-Bu-MdmrjhLVtQ"] #//
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
