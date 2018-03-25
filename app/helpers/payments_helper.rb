module PaymentsHelper
  def paypal_url(params = {})
    values = {
        cmd: '_xclick',
        charset: 'utf-8',
        business: 'accounting@jobsgalore.eu',
        return: params[:type]=='2' ? job_url(params[:id]) : resume_url(params[:id]),
        cancel_return: cancel_url_url,
        notify_url: payments_url,
        item_number:params[:item_number],
        item_name: params[:item_name],
        currency_code: 'AUD',
        amount: params[:price]}
    "https://www.paypal.com/cgi-bin/webscr?#{values.to_query}"
  end
end