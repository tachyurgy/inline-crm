class ApplicationController < ActionController::Base
  include ActionView::RecordIdentifier

  allow_browser versions: :modern
end
