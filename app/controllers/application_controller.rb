class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: 'admin', password: ENV['BASIC_AUTH_ADMIN_PASSWORD']
end
