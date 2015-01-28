require 'rails_helper'

RSpec.describe DefenceRequestsControllerPolicy do
  subject { DefenceRequestsControllerPolicy }

  [:index?].each do |action|
    permissions action do
      it "grants access to #{action} user role is 'cso'" do
        expect(subject).to permit(User.new(role: :cso), DefenceRequestsController)
      end
    end
  end
end
