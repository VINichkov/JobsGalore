class ApplicationWorkflow
  delegate :url_helpers, to: 'Rails.application.routes'

  attr_accessor :state, :class, :notice

    def self.desirialize(arg)
      if  arg.class == Hash and arg["class"]
        eval "#{arg["class"]}.desirialize(#{arg})"
      else
        arg
      end
    end

    def initialize(*arg)

    end

    def url
      update
    end


    def update

    end



end
