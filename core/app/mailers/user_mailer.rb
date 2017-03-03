class UserMailer < ApplicationMailer
  def sendUpdateLog(filename,date,user)
    # check parameter
    raise "user is nil" if user.nil?
    @filename =  !filename.nil? ? filename : nil
    @date = !date.nil? ? date : DateTime.now.strftime("%d/%m/%Y à %H:%M:%S");

    # config template var
    @email  = user.email

    @app_name =  Rails.application.class.parent

    # url's application
    @app_url = Geocms::Preference.joins(:account).where("geocms_accounts.default = true  and geocms_preferences.name = 'host'" ).take

    # url for get log file in tempalte
    @url = !@app_url.nil? && !@filename.nil?  ? @app_url.value + "/api/v1/data_sources/get_log_file?filename="+ @filename : nil

    # send mail
    mail(to: @email, subject: 'Update layer')

    puts "send mail ok"
  end
end
