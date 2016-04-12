# Homepage (Root path)
set:sessions, true

get '/' do
  if session[:userid].nil?
    erb :'users/login'
  else
    @tracks = Track.all
    erb :'tracks/index'
  end
end

post '/authenticate_user' do
  user_email = params[:email]
  user_password = params[:password]
  @user = User.where('email = ? AND password = ?', user_email, user_password)
  if @user.count == 0
    erb :'users/login'
  else
    session[:userid] = @user[0].id
    redirect '/'
  end
end

get '/signup' do
  erb :'users/signup'
end

post '/createnewuser' do
  user_email = params[:email]
  user_password = params[:password]
  user_full_name = params[:full_name]
  @user = User.new(
    email: user_email,
    password: user_password,
    full_name: user_full_name
    )
  if @user.save
    erb :'users/login'
  end
end

# tracks POST
post '/tracks' do
  @track = Track.new(
    title: params[:title], 
    url: params[:url], 
    author: params[:author]
    )
  if @track.save
    redirect '/tracks'
  else
    erb :'tracks/new'
  end
end

# tracks New GET
get '/tracks/new' do
  erb :'tracks/new'
end

# View track by ID GET
get '/tracks/:id' do
  @track = Track.find params[:id]
  erb :'tracks/show'
end