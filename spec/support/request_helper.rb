module RequestHelper
  def valid_auth_header
    @valid_authorization ||= ActionController::HttpAuthentication::Basic.encode_credentials("admin", ENV['BASIC_AUTH_ADMIN_PASSWORD'])
    { 'HTTP_AUTHORIZATION' => @valid_authorization}
  end
end