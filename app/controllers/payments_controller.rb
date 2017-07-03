
class PaymentsController < ApplicationController
  #load_and_authorize_resource :client, only:[:edit, :update, :destroy]
  #before_action :set_client, only: [:show, :edit,:update, :destroy]
  #before_action :authenticate_client!
  protect_from_forgery except: [:create]


  def bill
    @param = payment_params
    if @param[:kind] == '2'
      @ad = Job.find_by_id(@param[:id])
    else
      @ad = Resume.find_by_id(@param[:id])
    end
    case @param[:option]
      when '1'
        amount='10.00'
        item_name = "Urgent"
      when '2'
        amount='20.00'
        item_name = "Ad Top"
      when '3'
        amount='5.00'
        item_name="Highlight"
    end
    @url = paypal_url(return_url:root_url, cancel_return_url:cancel_url_url, notify_url:payments_url,item_number:"#{@param[:option]}#{@param[:kind]}#{@param[:id]}",amount:amount,item_name:item_name)
  end

  def cancel_url

  end


  def index
    @payment = Payment.all
  end

  def create
    product_id = params[:item_number]
    Payment.create!(
        params: params.to_s,
        product_id: product_id,
        status: params[:payment_status],
        transaction_id: params[:txn_id]
    )
    render nothing: true
  end

  private

  def paypal_url(params = {})

    values = {
        cmd: '_xclick',
        charset: 'utf-8',
        business: 'v.nichkov@hotmail.com',
        return: params[:return_url],
        cancel_return: params[:cancel_return_url],
        notify_url: params[:notify_url],
        item_number:params[:item_number],
        item_name: params[:item_name],
        currency_code: 'AUD',
        amount: params[:amount]}
    "https://www.sandbox.paypal.com/cgi-bin/webscr?#{values.to_query}"
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_params
    params.require(:bill).permit(:id, :kind, :option).to_h
  end


end