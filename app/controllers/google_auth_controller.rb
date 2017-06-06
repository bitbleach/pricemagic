require 'signet/oauth_2/client'
require 'google/apis/analytics_v3'
class GoogleAuthController < ApplicationController
  def show

  end

  def new
    client = ::Signet::OAuth2::Client.new({
    client_id: ENV.fetch('GOOGLE_API_CLIENT_ID'),
    client_secret: ENV.fetch('GOOGLE_API_CLIENT_SECRET'),
    authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
    scope: ::Google::Apis::AnalyticsV3::AUTH_ANALYTICS_READONLY,
    redirect_uri: "https://8f3ba121.ngrok.io/oauth2callback",
    token_credential_uri:  'https://www.googleapis.com/oauth2/v3/token',
    })
    redirect_to client.authorization_uri.to_s
  end
end
