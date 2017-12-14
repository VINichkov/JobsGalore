module IndustryHelper
  def by_category(arg={})
    content_tag(:div, class:"row")do
      content_tag(:div, class:"col-lg-12 col-md-12")do
        content_tag(:div, class:"well")do
          content_tag(:ul, class:"nav nav-list")do
            li= content_tag(:li, class:"nav-header")do
              content_tag(:h4, "#{arg[:name]} by Category")
            end
            li+=arg[:category].reduce(' ') { |a, elem|
              a << content_tag(:li, class:"col-sm-6 col-md-4 col-lg-4")do
                link_to elem.name, "/#{elem.id}/#{arg[:code]}"
              end
            }.html_safe
          end
        end
      end
    end
  end
end
