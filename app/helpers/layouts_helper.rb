module LayoutsHelper

  def tinymce_script
    tinymce_assets
    javascript_tag "tinymce.init(tinyEditorOptions);"
  end

end