class PaymentsController < ApplicationController
  #load_and_authorize_resource :client, only:[:edit, :update, :destroy]
  #before_action :set_client, only: [:show, :edit,:update, :destroy]
  #before_action :authenticate_client!

  def bill

  end

  private
  def paypal_url(return_url, cancel_return_url)
    values = {
        cmd: '_xclick',
        charset: 'utf-8',
        business: 'seller@example.com',
        return: return_url,
        cancel_return: cancel_return_url,
        item_number: id,
        item_name: name,
        currency_code: 'AUD',
        amount: value
    }
    "https://www.sandbox.paypal.com/cgi-bin/webscr?#{values.to_query}"
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:bill).permit(:id, :kind, :option)
  end
end