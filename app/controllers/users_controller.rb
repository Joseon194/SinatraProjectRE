class UsersController < ApplicationController

      get '/signup' do
          if Helpers.is_signed_in?(session)
              redirect to '/home'
          else
              erb :'/users/signup'
          end
      end

      post '/signup' do
        if !(params.has_value?(""))
            user = User.create(params)
            session["user_id"] = user.id
            redirect to '/home'
        else
            redirect to '/signup'
        end
    end

    get '/signin' do
          if Helpers.is_signed_in?(session)
              redirect to '/home'
          else
              erb :'/users/signin'
          end
      end


      post '/signin' do
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect to '/home'
        else
            redirect to '/signin'
        end
    end

    get '/home' do
      if Helpers.is_signed_in?(session)
          erb :'/users/home'
      else
          redirect to '/signin'
      end
  end


  post '/signout' do
        if Helpers.is_signed_in?(session)
            session.clear
            redirect to '/signin'
        else
            redirect to '/'
        end
    end
end
