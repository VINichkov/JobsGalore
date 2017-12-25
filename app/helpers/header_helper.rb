module HeaderHelper
  def logo(arg={})
    image_tag(image_path("method-draw-image.png"), size: arg[:size], alt:"Jobs Galore")
  end
  def print_header
    content_tag(:div, class: "print_header"){
      content_tag(:div, class: "container"){
        content_tag(:div){
          content_tag(:span){
            logo(size: "200x100")
          }
        }
      }
    }
  end
  def not_print
    content_tag(:div, class: "container-fluid hidden-xs hidden-sm hidden-md not_print"){
      content_tag(:div, class: "container"){
        content_tag(:h1){
          content_tag(:span){
            logo(size: "200x100")
          }
        }
      }
    }
  end

  def messege_in (arg = {})
    if arg[:message] then
      content_tag(:div, class: "container") {
        content_tag(:p,  arg[:message], class: arg[:class])
      }
    end
  end

end