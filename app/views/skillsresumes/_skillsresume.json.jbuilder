json.extract! skillsresume, :id, :name, :level_id, :resume_id, :created_at, :updated_at
json.url skillsresume_url(skillsresume, format: :json)