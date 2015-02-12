require "rails_helper"

RSpec.describe Mailer, :type => :mailer do
  subject { Mailer }
  let(:defence_request) { FactoryGirl.create(:defence_request) }
  let(:solicitor) { FactoryGirl.create(:solicitor_user) }

  describe 'notify_interview_start_change' do
    it 'contains a link to the request' do
      response = subject.notify_interview_start_change(defence_request, solicitor).deliver_now
      expect(response.body).to have_content 'a show url is totally going here when it is actually implemented'
    end
  end
end
