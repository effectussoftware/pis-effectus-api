class Api::V1::Admin::CommunicationController < ApplicationController
  before_action :set_communication, :only, [:show, :update, :destroy]

  def create
    @communication = Communication.create!(communication_params)
  end

  def index
    @communications = Communication.all
  end

  def update
    @communication.update!(communication_params)
  end

  def set_communication
    @communication = Communication.find(params[:id])
  end

  def communication_params
    params.require(:communication).permit(:title, :text, :published)
  end
end
