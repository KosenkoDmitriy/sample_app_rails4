class PushNotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'open-uri'
  require 'json'

  def index

    @result = JSON.parse(open("http://127.0.0.1:3001/api/products").read)

#    @reg_ids = RegistrationId.uniq.pluck(:reg_id)
    @android_reg_ids = AndroidDeviceToken.uniq.pluck(:token)
    @apple_reg_ids = AppleDeviceToken.uniq.pluck(:token)
    if (!" ".blank?)
      @hello = "hello from controller"
    end
  end


  def verify
    send_file "app/assets/googlecfc212ce9fce9cf8.html", :type=>"application/zip"
  end


  def new_apple_device
    if (!params[:token].blank?)
      if (AppleDeviceToken.find_by(:token => params[:token]).nil?)
        d = AppleDeviceToken.new(:token => params[:token])
        d.save!
      end
    end
  end


  def new_android_device
    if (!params[:token].blank?)
      if (AndroidDeviceToken.find_by(:token => params[:token]).nil?)
        d = AndroidDeviceToken.new(:token => params[:token])
        d.save!
      end
    end
  end


  def google
#    app = Rapns::Gcm::App.new
#    app.name = "name.adec.android.shop"
#    app.auth_key = "AIzaSyATuvf45LsCZ6A4p6B4wLkeqTa_Fm0E_G8" #"AIzaSyDDBzIQOhaN5iXGjPeIBnIJNWP2t0QUz8E" #"AIzaSyBjHSYGd3ufpk0v76o5v-Bu-MdmrjhLVtQ"
#    app.connections = 1
#    app.save!

#    @user = RegistrationId.new # (reg_id: "sadfsaf131fasd" )
#    @user.reg_id = params[:id]
#    #if @user.save
#      # Handle a successful save.
#    @user.save()
    
#    @reg_ids = RegistrationId.uniq.pluck(:reg_id)
    
    @reg_ids = AndroidDeviceToken.uniq.pluck(:token)

    n = Rapns::Gcm::Notification.new
    n.app = Rapns::Gcm::App.find_by_name("adec_shop_android") #name.adec.android.shop")
    n.registration_ids = @reg_ids #[ params[:id],  ] # ["1","2","3"] #["AIzaSyBjHSYGd3ufpk0v76o5v-Bu-MdmrjhLVtQ"] #//
    n.data = {:message => "message hi adec llc!", :title => "title 1", :text => "text 1", :image => "adec", :code => "123"}
    n.save!
    
#    Rapns.push
#  Rapns.shutdown
#  Rapns.embed
  
  end


  def apple
    #TODO: generate SSL certificate https://github.com/ileitch/rapns/wiki/Generating-Certificates
#    app = Rapns::Apns::App.new
#    app.name = "ios_app"
#    app.certificate = File.read("config/database.yml") # File.read("/path/to/sandbox.pem")
#    app.environment = "sandbox" # APNs environment.
#    app.password = "certificate password"
#    app.connections = 1
#    app.save()
    

#    @user = RegistrationId.new # (reg_id: "sadfsaf131fasd" )
#    @user.reg_id = params[:id]
#    #if @user.save
#      # Handle a successful save.
#    @user.save()
#    
#    @reg_ids = RegistrationId.uniq.pluck(:reg_id)
    @reg_ids = AppleDeviceToken.uniq.pluck(:token)
    
    @reg_ids.each do | token |
      n = Rapns::Apns::Notification.new
      n.app = Rapns::Apns::App.find_by_name("adec_shop_ios")
      n.device_token = token
      n.alert = "hi adec llc!"
      n.attributes_for_device = {:badge => "1", :sound => "default", :message => "message hi adec llc!", :title => "title 1", :text => "text 1", :image => "adec", :code => "123"}

      n.save!
    end
  
#    Rapns.push
#    Rapns.shutdown
#    Rapns.embed
  
  end


  def android_and_ios_json
    if ((!params[:title].blank?) && (!params[:text].blank?))

      title = params[:title]
      text = params[:text]

      @android_reg_ids = AndroidDeviceToken.uniq.pluck(:token)

      n = Rapns::Gcm::Notification.new
      n.app = Rapns::Gcm::App.find_by_name("adec_shop_android") #name.adec.android.shop")
      n.registration_ids = @android_reg_ids #[ params[:id],  ] # ["1","2","3"] #["AIzaSyBjHSYGd3ufpk0v76o5v-Bu-MdmrjhLVtQ"] #//
      n.data = {:message => "message hi adec llc!", :title => title, :text => text, :image => "adec", :code => "123"}
      n.save!


      @reg_ids = AppleDeviceToken.uniq.pluck(:token)

      @reg_ids.each do | token |
        n = Rapns::Apns::Notification.new
        n.app = Rapns::Apns::App.find_by_name("adec_shop_ios")
        n.device_token = token
        n.alert = "hi adec llc!"
        n.attributes_for_device = {:badge => "1", :sound => "default", :title => title, :text => text, :image => "adec", :code => "123"}
        n.save!
      end

    end
  end
end
