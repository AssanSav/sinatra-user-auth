class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home #renders the home page with a welcome message and a Sign Up and In links
  end

  get '/registrations/signup' do
    erb :'/registrations/signup' #displays the Name, Email and password columns for Sign Up
  end

  post '/registrations' do
    @user = User.create(name: params["name"], email: params["email"], password: params["password"])
    session[:user_id] = @user.id
    redirect '/users/home' 
  end

  get '/sessions/login' do
    # the line of code below render the view page in app/views/sessions/login.erb
    erb :'sessions/login'
  end

  post '/sessions' do
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      redirect '/users/home' #Displays the user Signed In page
    end
    redirect '/sessions/login'
  end

  get '/sessions/logout' do
    session.clear
    redirect '/'
  end

  get '/users/home' do
    @user = User.find(session[:user_id])
    erb :'/users/home'
  end
end
