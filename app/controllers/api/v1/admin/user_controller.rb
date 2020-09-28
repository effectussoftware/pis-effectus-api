module Api
    module V1
        module Admin
            class UserController < Api::V1::Admin::AdminApiController
   
                def index
                    users = User.all
                    render json:users, status: :ok
                end
                
                def show
                    user = User.find(params[:id])
                    render json:user, status: :ok
                end
                
                def update
                    user = User.find(params[:id])
                    user.update!(update_params)
                    render json:user, status: :ok
                end
            
                private

                def update_params
                    params.require(:user).permit(:is_admin, :is_active)
                end
            end 
        end
    end
end


