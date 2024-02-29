require 'rails_helper'

RSpec.describe 'Splash screen', type: :request do
  describe 'GET /' do
    before { get root_path }

    it 'renders the splash screen' do
      get root_path
      expect(response.body).to include('Smart Budget App')
      expect(response.body).to include('LOG IN')
      expect(response.body).to include('SIGN UP')
    end

    it 'renders the splash screen' do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
