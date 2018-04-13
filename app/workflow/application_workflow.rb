class ApplicationWorkflow
  delegate :url_helpers, to: 'Rails.application.routes'

  attr_accessor :state, :class

    def self.desirialize(arg)
      Rails.logger.debug("ApplicationWorkflow::desirialize arg = #{arg.to_json}")
      if arg["class"]
        Rails.logger.debug "#{arg["class"]}.desirialize(#{arg})"
        eval "#{arg["class"]}.desirialize(#{arg})"
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
