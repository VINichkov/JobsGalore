module LayoutsHelper

  def tinymce_script
    javascript_tag "tinymce.init(tinyEditorOptions);"
  end

end