class MailingController < ApplicationController

  before_action :set_company, only: :contacts_of_companies
  before_action :set_mailing, only: :destroy
  before_action :authenticate_client!, only: [:contacts_of_companies, :show, :destroy]

  def contacts_of_companies
    @elements = EmailHr.all_for_view(@filter)
  end

  def create
    letter = CreateLetter.call(params:params, client: current_client.id)
    redirect_to paypal_url(letter.url) #TODO проверить и доделать переход в платежый шлюз
  end

  def destroy
    @mailing.destroy
    render json: { message: "done" }, status: :ok
  end

  def show
    @mailings = Mailing.where(client_id: current_client).order(created_at: :desc).map do |t|
      res = t.to_h
      res[:destroy_url] = mailing_url(t.id)
      res[:pay_url] = 'nil'
      res
    end
  end

  private

  def set_company
    @filter = params[:name]
  end

  def set_mailing
    @mailing =  Mailing.find(params[:id])
  end



end