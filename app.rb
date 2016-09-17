require 'sinatra'
require_relative 'config/application'
require 'pry'

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = Meetup.order(:name)
  erb :'meetups/index'
end

get '/new' do
  @errors = nil
  @meetups = Meetup.order(:name)
  if session[:user_id]
    erb :'meetups/new'
  else
    flash[:notice] = "You must sign in first."
  end
end

post '/new' do
  @name = params[:Name]
  @description = params[:Description]
  @time = params[:Time]
  @location = params[:Location]

  @meetup_obj = Meetup.new(
    name: @name,
    description: @description,
    time: @time,
    location: @location,
    user: current_user
  )

  if @meetup_obj.valid?
    @meetup_obj.save
    @creation_message = "Meetup successfully created"
    erb :'/meetups/show'
  else
    @errors = @meetup_obj.errors.full_messages
    erb :'/meetups/new'
  end
end

post '/meetups/:id' do
  if current_user.nil?
    flash[:notice] = "You must be signed in."
    redirect "/meetups/#{params[:id]}"
  else
    @signups = Signup.new(
      meetup_id: params[:id],
      user: current_user
    )

    if @signups.save
      flash[:notice] = "Signup successful"
      redirect "/meetups/#{params[:id]}"
      erb :'/meetups/show'
    else
      flash[:notice] = "Signup unsuccessful"
      erb :'/meetups/new'
    end
  end
end

get '/meetups/:id' do
  @current_user = current_user
  @signups = Meetup.find(params[:id])
  @creation_message = nil
  @meetup_obj = Meetup.find(params[:id])
  erb :'meetups/show'
end
