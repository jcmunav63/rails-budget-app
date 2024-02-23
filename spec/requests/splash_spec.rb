require 'rails_helper'

RSpec.describe 'Splash screen', type: :request do
  describe 'GET /' do
    before { get root_path }

    it 'renders the splash screen' do
      get root_path
      expect(response.body).to include('Smart Budget App')
      expect(response.body).to include('Log in')
      expect(response.body).to include('Sign up')
    end

    it 'renders the splash screen' do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
