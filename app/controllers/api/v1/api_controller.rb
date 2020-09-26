# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      include Api::V1::ExceptionHandler

      alias current_user current_api_v1_user
    end
  end
end
