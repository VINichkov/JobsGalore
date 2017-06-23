class PaymentsController < ApplicationController
  #load_and_authorize_resource :client, only:[:edit, :update, :destroy]
  #before_action :set_client, only: [:show, :edit,:update, :destroy]
  #before_action :authenticate_client!

  def bill
    @req =  client_params
  end

  private
  def set_client

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:bill).permit(:id, :kind, :option)
  end
end