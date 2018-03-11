
class PaymentsController < ApplicationController
  #before_action :set_client, only: [:show, :edit,:update, :destroy]
  #before_action :authenticate_client!
  protect_from_forgery except: [:create]
  load_and_authorize_resource only:[:index, :show]

  def bill
    @param = payment_params
    begin
      if @param[:type] == '2'
        @ad = Job.find_by_id(@param[:id]).decorate
        return_url = job_url(@param[:id])
      else
        @ad = Resume.find_by_id(@param[:id]).decorate
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
      puts "!!________________#{@ad}!!________"
      if @ad.blank? or amount.blank?
        puts "!!___________________Зашли"
        raise ArgumentError, "No parameters"
      end
      puts payments_url
      @url = paypal_url(return_url:return_url, cancel_return_url:cancel_url_url, notify_url:payments_url,item_number:"#{@param[:option]}#{@param[:kind]}#{@param[:id]}",amount:amount,item_name:item_name)
    rescue
      redirect_to render_404
    end
  end

  def cancel_url

  end


  def index
    @payment = Payment.all
  end

  def create
    option = params[:item_number][0]
    kind=params[:item_number][1]
    product_id = params[:item_number][2..params[:item_number].length-1]
    Payment.create!(
        params: params.to_s,
        product_id: product_id,
        kind:kind,
        kindpay:option,
        status: params[:payment_status],
        transaction_id: params[:txn_id]
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
    "https://www.paypal.com/cgi-bin/webscr?#{values.to_query}"
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def payment_params
    params.require(:bill).permit(:id, :type, :option).to_h
  end


end