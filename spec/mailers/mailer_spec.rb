require "rails_helper"

RSpec.describe Mailer, :type => :mailer do
  subject { Mailer }
  let(:defence_request) { FactoryGirl.create(:defence_request, interview_start_time: Time.at(1423757676).to_datetime) }
  let(:solicitor) { FactoryGirl.create(:solicitor_user) }

  describe 'notify_interview_start_change' do
    before do
      @response = subject.notify_interview_start_change(defence_request, solicitor).deliver_now
    end

    it 'contains a link to the request' do
      expect(@response.body).to have_content 'a show url is totally going here when it is actually implemented'
    end

    it 'contains the new start time' do
      expect(@response.body).to have_content '16:14'
    end
  end
end
