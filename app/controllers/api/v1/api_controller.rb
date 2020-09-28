module Api
    module V1
        class ApiController < ApplicationController
            include Api::V1::ExceptionHandler
        end
    end
end

