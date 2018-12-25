class Main
  include Interactor

  def call
    puts context.query
    if context.query && context.query["location_id"].present?
      context.jobs = JobDecorator.decorate_collection(Job.select(:id, :title,:description, :location_id, :company_id, :updated_at).where(location_id: context.query["location_id"]).includes(:location,:company).last(10).reverse)
    else
      context.jobs = JobDecorator.decorate_collection(Job.select(:id, :title,:description, :location_id, :company_id, :updated_at).includes(:location,:company).last(10).reverse)
    end
    context.city = Location.major
  end
end
