#encoding:utf-8
class ResetPasswordMailer < ActionMailer::Base
  default from: "Cheuks<cs@iotps.com>"


  def reset_password_email(user)
  	@user = user
  	 site  = "http://weishop.cheuks.com"

  	@reset_password_url = "#{site}/users/reset_password?u=#{@user.member_id}&token=#{@user.reset_password_token}"
  	mail(:to => user.email, :subject => "忘记密码")
  end


  def reset_password_email_vshop(user)
    @user = user
    # site  = "http://weishop.cheuks.com"
     site="http://0.0.0.0:3000"
    @reset_password_url = "#{site}/users/reset_password?u=#{@user.member_id}&token=#{@user.reset_password_token}&platform=vshop"
    mail(:to => user.email, :subject => "忘记密码")
  end



end
