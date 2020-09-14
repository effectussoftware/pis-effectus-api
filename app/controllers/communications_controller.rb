class CommunicationsController < ApplicationController

  def create
    params.permit!
    @communication = Communication.new(
      title: params[:data][:title],
      text: params[:data][:text],
    )
    @communication.save
    render json: @communication.id
  end

  def edit
    @communication = Communication.find(params[:id])
    @communication.save(params)
    render json: @communication
  end

  def show
    @communication = Communication.find(params[:id])
    render json: @communication
  end

  def index
    @communications = Communication.all
    render json: @communications
  end

  def destroy
    @communication = Communication.find(params[:id])
    @communications.destroy
  end

end
