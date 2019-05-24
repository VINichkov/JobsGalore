class Admin::CompaniesController < ApplicationController
  before_action :set_company, only: [ :edit]

  def edit; end


  def update
    company = Admin::UpdateCompany.call(params:company_params)
    render json: { message: "done" }, status: :ok  if company.success?
  end

  private
  def set_company
    @company = Admin::EmailsOfCompany.find_by_id(params[:id])
  end

  def company_params
    params.permit(:id, :action_executed, :data)
  end
end