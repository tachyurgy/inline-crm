class ApplicationController < ActionController::Base
  include ActionView::RecordIdentifier
  include Pagy::Backend

  allow_browser versions: :modern
end
