class ErrorsController < ApplicationController
  def error_404
    @main = Main.call(query:@search)
    render file: "errors/error_404", status: :not_found
  end
end