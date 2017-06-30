class PaymentsController < ApplicationController
  #load_and_authorize_resource :client, only:[:edit, :update, :destroy]
  #before_action :set_client, only: [:show, :edit,:update, :destroy]
  #before_action :authenticate_client!
  protect_from_forgery except: [:create]

  def bill
    @url = paypal_url(root_url, cancel_url_url, payments_url)
  end

  def cancel_url

  end


  def index
    @payment = Payment.all
  end

  def create
    product_id = params[:item_number]
    Payment.create!(
        params: params.to_h.to_s,
        product_id: product_id,
        status: params[:payment_status],
        transaction_id: params[:txn_id]
    )
    render nothing: true
  end

  private

  def paypal_url(return_url, cancel_return_url, notify_url)
    puts return_url
    puts cancel_return_url
    puts notify_url
    values = {
        cmd: '_xclick',
        charset: 'utf-8',
        business: 'FreeTalents',
        return: return_url,
        cancel_return: cancel_return_url,
        notify_url: notify_url,
        item_name: "Urgent",
        currency_code: 'AUD',
        image_url: image_path("method-draw-image.svg"),
        amount: "10.00"    }
    "https://www.sandbox.paypal.com/cgi-bin/webscr?#{values.to_query}"
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:bill).permit(:id, :kind, :option)
  end


end