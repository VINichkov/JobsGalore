class CreateJob
  def initialize
    @connect = ConnectPg.instance.connect
    @@size ||= Size.new(@connect).call
    @@industry ||= Industry.new(@connect).call
  end

  def call(**arg)
    company_id  = arg[:company_id] || CreateCompany.new(@connect).call(name: arg[:company],
                                                                       size: @@size,
                                                                       location: arg[:location],
                                                                       industry_id: @@industry )

    client_id = FindClient.new(@connect).call(company_id: company_id) if arg[:company_id]
    client_id ||= CreateClient.new(@connect).call(firstname: arg[:company], location: arg[:location], company_id: company_id)
    puts "Сохраняем #{arg[:title]}  в #{arg[:location]}"



  end

  def self.automatic_create(**job)
=begin
    company = Company.find_by_names_or_name(job[:company])
    if company.nil?
      company = Company.create(name: job[:company], size: Size.first, location_id: job[:location])
    end
=end
=begin
    user = company.client.first
    if user.blank?
      email = "#{job[:company].delete("<>{}#@!,.:*&()'`\"’").tr(' ', '_')}#{(0...8).map { rand(97..121).chr }.join}@email.com.au"
      puts email
      user = Client.new(firstname: job[:company], lastname: 'HR', email: email, location_id: job[:location], character: TypeOfClient::EMPLOYER, send_email: false, password: '11111111', password_confirmation: '11111111', company_id: company.id)
      user.skip_confirmation! if Rails.env.production?
      user.save!
    end
=end
    Rails.logger.debug "Сохраняем #{job[:title]}  в #{job[:location]}"
    Job.create!(title: 'first', location_id: 22, salarymin: 1, salarymax: 2, description: 'Описание',  company_id: 456345, client_id: 456345, sources: 'Источник', apply: 'приемник')
  end

  private

  def create_company()
    CreateCompany
  end

end