# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      include Api::V1::ExceptionHandler
      before_action :authenticate_api_v1_user!
    end
  end
end
