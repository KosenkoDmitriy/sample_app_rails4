class PushNotificationsController < ApplicationController
  skip_before_action :verify_authenticity_token
  require 'open-uri'
  require 'json'

  def index

    #@result = JSON.parse(open("http://127.0.0.1:3001/api/products").read)

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


  def create_gcm_app
    app = Rpush::Gcm::App.new
    app.name = "name.adec.android.shop"
    app.auth_key = "AIzaSyATuvf45LsCZ6A4p6B4wLkeqTa_Fm0E_G8" #"AIzaSyDDBzIQOhaN5iXGjPeIBnIJNWP2t0QUz8E" #"AIzaSyBjHSYGd3ufpk0v76o5v-Bu-MdmrjhLVtQ"
    app.connections = 1
    app.save!
  end


  def create_apns_app
    #TODO: generate SSL certificate https://github.com/ileitch/rapns/wiki/Generating-Certificates
    app = Rpush::Apns::App.new
    app.name = "name.adec.ios.shop"
    app.certificate = File.read("/path/to/sandbox.pem")
    app.environment = "sandbox" # APNs environment.
    app.password = "certificate password"
    app.connections = 1
    app.save()
  end


  def news
    if ((!params[:title].blank?) && (!params[:text].blank?) && (!params[:app][:ios].blank?) && (!params[:app][:android].blank?))
      
      title = params[:title]
      text = params[:text]
      app_android = params[:app][:android]
      app_ios = params[:app][:ios]
      image = "default.png"

      android_params = {:message => text, :title => title, :text => text, :image => image}
      android_push_notification app_android, android_params

      ios_params = {:badge => "1", :sound => "default", :title => title, :text => text, :image => image}
      ios_push_notification app_ios, ios_params
      
    end
  end
  
  def sync
    if ((!params[:sync].blank?) && (!params[:title].blank?) && (!params[:text].blank?) && (!params[:app][:ios].blank?) && (!params[:app][:android].blank?))
      
      title = params[:title]
      text = params[:text]
      app_android = params[:app][:android]
      app_ios = params[:app][:ios]
      sync = params[:sync]
      image = "default.png"

      android_params = {:message => text, :title => title, :text => text, :image => image, :sync => sync}
      android_push_notification app_android, android_params

      ios_params = {:badge => "1", :sound => "default", :title => title, :text => text, :image => image, :sync => sync}
      ios_push_notification app_ios, ios_params
      
    end
  end


  def android_push_notification ( app_id, android_params)
    android_reg_ids = AndroidDeviceToken.uniq.pluck(:token)
  
    n = Rpush::Gcm::Notification.new
    n.app = Rpush::Gcm::App.find_by_name(app_id)
    n.registration_ids = android_reg_ids #[ params[:id],  ] # ["1","2","3"] #["AIzaSyBjHSYGd3ufpk0v76o5v-Bu-MdmrjhLVtQ"] #//
    n.data = android_params
    n.save!
  end
  
  def ios_push_notification (app_id, ios_params)
    reg_ids = AppleDeviceToken.uniq.pluck(:token)
  
    reg_ids.each do | token |
      n = Rpush::Apns::Notification.new
      n.app = Rpush::Apns::App.find_by_name(app_id)
      n.device_token = token
      n.alert = ios_params[:text]
      n.attributes_for_device = ios_params
      n.save!
    end
  end
    
end
