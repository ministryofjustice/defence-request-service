class JSONParser < Faraday::Response::Middleware
  def parse(body)
    json = MultiJson.load(body, symbolize_keys: true)
    data = json.keys.first
    {
      data: json[data],
      metadata: json[:extra],
      errors: json[:errors]
    }
  end
end

url = "#{ENV['AUTHENTICATION_SITE_URL']}/api/#{ENV['AUTHENTICATION_API_VERSION']}/"
conn = ::Faraday.new(url: url) do |c|
  c.request   :json
  c.use       JSONParser
  c.adapter   ::Faraday.default_adapter
end

Spyke::Base.connection = conn

# Monkey-patched Spyke to enable per request setting of AUTHORIZATION token.
# This is how to set user_token:
#    user_token = "Bearer #{session['user_token']}"
#    o = Organisation.where(user_token: user_token).find(organisation_uid)
# Result:
#    <Organisation(organisations) id: nil
#      uid: "a24f1ded-6cd8-4322-bd43-ed9199a4adb4"
#      name: "Law Firm"
#      type: "law_firm"
#      links: {"profiles"=>"/api/v1/profiles/uids[]=319bf1b6-c288-489b-a458-844d7466e9a6&uids[]=12c0b5cc-5314-430c-a627-067479aec9dc&uids[]=d7df383d-b80c-48ef-920d-431c948ae60a&uids[]=b2d53e5f-6255-4fa4-b6ad-71871b8b28ae&uids[]=6940a734-0234-49fa-9a3f-c0ee0e00e9cb"}>
module Spyke
  module Http
    module ClassMethods
      def request(method, path, params = {})
        user_token = params.delete(:user_token) # <- monkey-patch line
        ActiveSupport::Notifications.instrument('request.spyke', method: method) do |payload|
          response = connection.send(method) do |request|
            request.headers['AUTHORIZATION'] = user_token if user_token # <- monkey-patch line
            if method == :get
              request.url path.to_s, params
            else
              request.url path.to_s
              request.body = params
            end
          end
          payload[:url], payload[:status] = response.env.url, response.status
          Result.new_from_response(response)
        end
      end
    end
  end
end

