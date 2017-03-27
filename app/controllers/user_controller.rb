class UserController < ApplicationController
  def index
    if session.key?(:id)
      redirect_to '/songs/index'
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    unless @user
      redirect_to '/'
    end
  end

  def login
    user = User.find_by_email(params[:email]).try(:authenticate, params[:password])
    if user
      session[:id] = user.id
      session[:name] = user.name
      redirect_to '/songs/index'
    else
      flash[:errors] = ['Login failure, try again or register new account']
      redirect_to '/'
    end
  end

  def logout
    session.clear
    redirect_to '/'
  end

  def register
    user = User.create(name:params[:name], email:params[:email], password:params[:password], password_confirmation:params[:confirm_password])
    if user.id
      session[:id] = user.id
      session[:name] = user.name
      redirect_to '/songs/index'
    else
      flash[:errors] = ['registration issues, make sure passwords match']
      redirect_to '/'
    end
  end
end
