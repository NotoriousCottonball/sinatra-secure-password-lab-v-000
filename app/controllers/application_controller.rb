require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base
  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    response.set_cookie("credit_amount", :value => "secret_value")
    erb :index
  end

  get '/signup' do
     @cookie = request.cookies["credit_amount"]
     erb :signup
  end

  post "/signup" do
    #your code here
    if params[:username] == "" || params[:password] == ""
      redirect "/failure"
    else
      User.create(:username => params[:username], :password => params[:password])
      redirect "/login"
    end
  end

  get "/account" do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    ##your code here
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/account"
    else
      redirect "/failure"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
