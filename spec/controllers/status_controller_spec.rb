require 'rails_helper'

RSpec.describe StatusController, type: :controller do

  describe "GET index" do
    it 'returns 200 status code' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    context 'HTML request' do
      it 'returns OK in body' do
        get :index
        expect(response.body).to include("OK")
      end
    end

    context 'JSON request' do
      it 'returns a JSON status "OK"' do
        get :index, format: 'json'
        expect(JSON.parse response.body.strip).to eq({"status" => "OK"})
      end
    end

    context 'XML request' do
      it 'returns a XML status "OK"' do
        get :index, format: 'xml'
        expect(response.body.strip).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Response>\n  <Status>OK</Status>\n</Response>")
      end
    end

    context 'other MIME type' do
      it 'returns OK in body' do
        get :index, format: 'text'
        expect(response.body).to include("OK")
      end
    end
  end
end
