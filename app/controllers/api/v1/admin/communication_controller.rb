class Api::V1::Admin::CommunicationController < ApplicationController

  before_action :set_communication, only: [:show, :update, :destroy]

  def create
    @communication = Communication.create!(communication_params)
    render json: @communications, status: :created
  end

  def index
    @communications = Communication.all
    render json: @communications, status: :ok
  end

  def update
    @communication.update!(communication_params)
    render json: @communication, status: :ok
  end

  def show
    render json: @communication, status: :ok
  end

  def destroy
    @communication.destroy
  end

  def set_communication
    @communication = Communication.find(params[:id])
  end

  def communication_params
    params.require(:communication).permit(:title, :text, :published)
  end
end