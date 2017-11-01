
class PaymentsController < ApplicationController
  load_and_authorize_resource
  #before_action :set_client, only: [:show, :edit,:update, :destroy]
  #before_action :authenticate_client!
  protect_from_forgery except: [:create]
  authorize_resource only:[:index, :show]

  def bill
    @param = payment_params
    if @param[:kind] == '2'
      @ad = Job.find_by_id(@param[:id])
      return_url = job_url(@param[:id])
    else
      @ad = Resume.find_by_id(@param[:id])
      return_url = resume_url(@param[:id])
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
    @url = paypal_url(return_url:return_url, cancel_return_url:cancel_url_url, notify_url:payments_url,item_number:"#{@param[:option]}#{@param[:kind]}#{@param[:id]}",amount:amount,item_name:item_name)
  end

  def cancel_url

  end


  def index
    @payment = Payment.all
  end

  def create
    param = params_for_create
    option = param[:item_number][0]
    kind=param[:item_number][1]
    product_id = param[:item_number][2..params[:item_number].length-1]
    Payment.create!(
        params: param.to_s,
        product_id: product_id,
        kind:kind,
        kindpay:option,
        status: param[:payment_status],
        transaction_id: param[:txn_id]
    )
    if kind=='2'
      job = Job.find_by_id(product_id)
      case option
        when '1'
          job.urgent_on
        when '2'
          job.top_on
        when '3'
          job.highlight_on
      end
    else
      resume = Resume.find_by_id(product_id)
      case option
        when '1'
          resume.urgent_on
        when '2'
          resume.top_on
        when '3'
          resume.highlight_on
      end
    end
    render nothing: true
  end

  private

  def paypal_url(params = {})
    values = {
        cmd: '_xclick',
        charset: 'utf-8',
        business: 'accounting@jobsgalore.eu',
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

  def params_for_create
    params
  end
end