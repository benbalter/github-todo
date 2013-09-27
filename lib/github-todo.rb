require 'octokit'
require 'sinatra_auth_github'
require 'securerandom'
require 'dotenv'
require 'rubygems'
require 'action_view'
include ActionView::Helpers::DateHelper

Dotenv.load

module GithubTodo
  class App < Sinatra::Base
    enable :sessions

    set :github_options, {
      :scopes    => "user,repo",
      :secret    => ENV['GITHUB_CLIENT_SECRET'],
      :client_id => ENV['GITHUB_CLIENT_ID'],
    }

    register Sinatra::Auth::Github
    use Rack::Session::Cookie, :secret => SecureRandom.hex

    before do
      authenticate!
    end

    def octokit
      Octokit::Client.new :access_token => env['warden'].user.token
    end

    def issues
      octokit.list_issues
    end

    # Demo
    get '/' do
      erb :index, :issues => issues
    end

  end
end
