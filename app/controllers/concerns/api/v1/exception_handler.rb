module Api
    module V1
        module ExceptionHandler
            extend ActiveSupport::Concern

            included do
                
                rescue_from ActiveRecord::RecordNotFound do |e|
                    render json: {error: e.message}, status: :not_found
                end

                rescue_from Exception do |e|
                    render json: {error: e.message}, status: 500
                end
            end
        end
    end
end