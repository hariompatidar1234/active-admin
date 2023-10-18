# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome_email
    # byebug
    @user = params[:user]
    mail(to: @user.email, subject: 'Welcome TO Uber_Eats !!')
  end

  def forgot_password_token
    @user = params[:user]
    return unless @user.email

    mail(to: @user.email, subject: 'Forgot Password Token')
  end
end
