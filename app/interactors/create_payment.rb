class CreatePayment
  include Interactor

  def call
    option = context.params[:item_number][0]
    type=context.params[:item_number][1]
    product_id = context.params[:item_number][2..params[:item_number].length-1]
    Payment.create(
        params: context.params.to_s,
        product_id: product_id,
        kind:type,
        kindpay:option,
        status: context.params[:payment_status],
        transaction_id: context.params[:txn_id]
    )
    type=='2' ? obj = Job.find_by_id(product_id) : obj=Resume.find_by_id(product_id)
    swich = {'1'=>:urgent, '2'=>:top, '3'=>:highlight}
    eval "obj.#{swich[option]}_on"
  end
end
