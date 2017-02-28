
class ApplicationMailer < ActionMailer::Base
  default from: "alkante@geocms.com"


  def sendUpdateLog(filename,date,user)
    puts "sendUpdateLog"
    @date = date
    @user = user.username
    @email  = user.email
    @filename = filename
    @app_name =  Rails.application.class.parent
    @app_url= Rails.application.config.action_mailer.default_url_options;
    @url = @app_url + "api/v1/data_sources/get_log_file?filename="+filename

    print("date : ",@date," ; email : ",@email," ; app_name : ",@app_name,"\n")
    print("app_url : ",@app_url," ; send to url : ",@url,"\n");

    puts "create mail"
    mymail = mail(to: @email, subject: 'Update layer')
    mymail.deliver
    puts "after deliver"
    puts "End"

  end
end
