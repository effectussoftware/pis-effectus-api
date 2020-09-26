class Api::V1::UserController < ApplicationController
    include Secure
    before_action :authenticate_admin!

    rescue_from Exception do |e|
        render json: {error: e.message}, status: 500
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
        render json: {error: e.message}, status: :not_found
    end

    def index
        users=User.all()
        render json:users, status: :ok
    end
    
    def show
        user=User.find(params[:id])
        render json:user, status: :ok
    end
    
    def update
        user=User.find(params[:id])
        user.update!(update_params)
        render json:user, status: :ok
    end

    private
    def update_params
        params.require(:user).permit(:is_admin,:is_active)
    end
    
end