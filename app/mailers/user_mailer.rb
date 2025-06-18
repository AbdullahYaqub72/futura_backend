class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @login_url = "#{ENV['SUPABASE_EMAIL_REDIRECT_URL']}/login"
    mail(to: @user.email, subject: 'Welcome to Our App') do |format|
      format.html
    end
  end
end