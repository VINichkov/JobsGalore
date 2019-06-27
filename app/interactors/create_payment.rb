# frozen_string_literal: true

class CreatePayment
  include Interactor

  def call
    @option = context.params[:item_number][0]
    @type = context.params[:item_number][1].to_i
    @product_id = context.params[:item_number][2..context.params[:item_number].length - 1]
    Payment.create(
      params: context.params.to_s,
      product_id: @product_id,
      kind: @type,
      kindpay: @option,
      status: context.params[:payment_status],
      transaction_id: context.params[:txn_id]
    )
    case type
    when 1..2
      promote
    when 4
      mailing
    else
      Rails.logger.error('Не опознанный платеж')
    end
  end

  private

  def promote
    swich = { '1' => :urgent_on, '2' => :top_on, '3' => :highlight_on }
    obj = @type == 2 ? Job.find_by_id(@product_id) : Resume.find_by_id(@product_id)
    obj.try(swich[@option])
  end

  def mailing
    Mailing.find_by_id(@product_id).pay!
  end
end
