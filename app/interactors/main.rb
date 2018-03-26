class Main
  include Interactor

  def call
    context.jobs = JobDecorator.decorate_collection(Job.select(:id, :title,:description, :location_id, :company_id, :updated_at).includes(:location,:company).last(10).reverse)
    context.city = Location.major
  end
end
