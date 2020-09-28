class Api::V1::Admin::AdminApiController < ApplicationController
    before_action :authenticate_admin!

    def authenticate_admin!
        if current_api_v1_user && current_api_v1_user["is_active"] && current_api_v1_user["is_admin"] 
            true
        else
            render json:{error:"Unauthorized"}, status: :unauthorized
        end
    end

end
