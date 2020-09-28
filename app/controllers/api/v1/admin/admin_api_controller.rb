module Api
    module V1
        module Admin
            class AdminApiController < Api::V1::ApiController
                before_action :authenticate_admin!
            
                def authenticate_admin!
                    if current_api_v1_user && current_api_v1_user['is_active'] && current_api_v1_user['is_admin'] 
                        true
                    else
                        render json: { error: 'Unauthorized' }, status: :unauthorized
                    end
                end
            end
        end
    end
end

