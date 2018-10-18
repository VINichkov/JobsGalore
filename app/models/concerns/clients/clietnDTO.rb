module ClientDTO
    extend ActiveSupport::Concern

    def full_name
      @full_name ||= self.firstname+' '+self.lastname
    end

    def to_short_h
      {id:id, firstname:firstname,
       lastname:lastname, email:email,
       phone:phone, password:password,
       photo_uid: photo_uid,
       gender:gender,
       location_id:location_id,
       character:character,
       company_id:company_id}
    end

    def resumes_for_apply
      resume.select(:id, :title, :salary, :description, :location_id, :industry_id).all.limit(5).includes(:location,:industry).map  do |t|
        {idr: t.id,
        title: t.title,
        location: t.location&.name,
        industry: t.industry&.name,
        salary: t.salary,
        description: t.description }
      end
    end
end