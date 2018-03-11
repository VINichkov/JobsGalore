module ApplicationHelper
  ALL = "highlight urgent"
  HIGHLIGHT = "highlight"
  URGENT = "urgent"

  def title(text)
    content_for :title, text
  end
  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end
  def yield_meta_tag(tag, default_text='')
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end

  def noindex
    content_for :noindex, true
  end

  def image_bg(url, bgsize,width, height, option={} )
    content_tag(:div,'', class: "#{option[:class] ? option[:class] : "text-center img-thumbnail center-block avatar"}", style: "background-image: url('#{url}');background-size: #{bgsize}; width: #{width}; height: #{height};")
  end

  def meta_head(arg={})
    title arg[:title]
    meta_tag "description",   arg[:description]
    meta_tag "keywords", arg[:keywords]
    meta_tag "og:type", arg[:type] ? arg[:type] : "article"
    meta_tag "og:title", arg[:title]
    meta_tag "og:description", arg[:description]
    meta_tag "og:url", arg[:url]
    meta_tag "og:image", arg[:image]
    meta_tag "article:published_time", arg[:published]
  end

  def class_extras(object)
    if object.highlight and object.urgent
      ALL
    elsif not object.highlight and object.urgent
      URGENT
    elsif object.highlight and not object.urgent
      HIGHLIGHT
    else
      ""
    end
  end

  def will_paginate_mini(objects)
    will_paginate objects, {renderer: BootstrapPagination::Rails, inner_window:1, outer_window:0, previous_label:'&#8592;', next_label: '&#8594;'}
  end
end
