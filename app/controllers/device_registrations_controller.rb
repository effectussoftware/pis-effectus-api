# frozen_string_literal: true

class DeviceRegistrationsController < ApplicationController
  def create
    puts params[:device][:token]
    render json: { the_cake: 'is a lie' }
  end
end
