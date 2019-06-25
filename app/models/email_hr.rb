class EmailHr < ApplicationRecord
  belongs_to :company
  belongs_to :location

  def self.all_for_view(filter=nil)
    sql = <<-SQL
    select
        e.id,  
        c.name as "company", 
        e.fio  as "office", 
        e.main as "main", 
        l.suburb || ', '|| l.state as "location", 
        i.name as "industry", 
        c.recrutmentagency as "recrutmentagency"
    from email_hrs e
      full outer join locations l
        on l.id = e.location_id,
      companies c,
      industries i
    where e.company_id = c.id
      and c.industry_id = i.id
      and e.send_email = true
    order by c.name ASC, "location" ASC
    SQL


    ActiveRecord::Base.connection.exec_query(sql).to_hash.map.with_index do |row, index|
      {index: index,
       check: (filter ==  row['company']) ? true : false,
       id: row['id'],
       company: row['company'],
       office: row['office'],
       main:row['main'],
       recrutmentagency: row['recrutmentagency'],
       industry:row['industry'],
       location:row['location'] ? row['location'] : 'Australia'}
    end
  end
end