# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def send_email(user)
    @user = user
    mail(to: @user.email, subject: 'Check your Results')
  end
end
