class CarsController < ApplicationController

    get '/cars/root' do
        user = Helpers.current_user(session)
        if user.nil?
            redirect to '/signin'
        else
            @cars = Car.all
            erb :'/cars/root'
        end
    end

    get '/cars/new' do
        user = Helpers.current_user(session)
        if user.nil?
            redirect to '/signin'
        else
            erb :'/cars/create_car'
        end
    end

    post '/cars/new' do
        user = Helpers.current_user(session)
        if user.nil?
            redirect to '/signin'
        elsif params[:car][:name].empty? || params[:car][:color].empty? || params[:car][:model_year].empty? || params[:car][:company].empty?
            redirect to '/cars/new'
        else
            user.cars.new({name: params[:car][:name], color: params[:car][:color], model_year: params[:car][:model_year], company: params[:car][:company]})
            user.save
        end
        redirect to '/cars/show'
    end

    get '/cars/show' do
        user = Helpers.current_user(session)
        if user.nil?
            redirect to '/signin'
        else
            @cars = user.cars.all
            erb :'/cars/show_cars'
        end
    end

    get '/cars/:id' do
        if Helpers.is_signed_in?(session)
            @cars = Car.find_by_id(params[:id])
            erb :'/cars/edit_or_delete'
        else
            redirect to '/signin'
        end
    end

    get '/cars/:id/edit' do
        if !Helpers.is_signed_in?(session)
            redirect to '/signin'
        end
        @car = Car.find_by_id(params[:id])
        if @car.user == Helpers.current_user(session)
            erb :'/cars/edit_car'
        else
            redirect to '/signin'
        end
    end

    patch '/cars/:id' do
        if !Helpers.is_signed_in?(session)
            redirect to '/signin'
        end
        @car = Car.find_by_id(params[:id])
        if params[:car][:name].empty? || params[:car][:color].empty? || params[:car][:model_year].empty? || params[:car][:company].empty?
            redirect to "/cars/#{@car.id}/edit"
        end
        @car.update(params[:car])
        @car.save
        redirect to '/cars/show'
    end

    delete '/cars/:id/delete' do
        if !Helpers.is_signed_in?(session)
            redirect to '/signin'
        end
        @car = Car.find_by_id(params[:id])
        if @car.user == Helpers.current_user(session)
            @car.delete
            redirect to '/cars/show'
        end
    end
end
