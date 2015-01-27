require 'rails_helper'

RSpec.describe DefenceRequestControllerPolicy do
  subject { DefenceRequestControllerPolicy }

  [:index?].each do |action|
    permissions action do

      it "grants access to #{action} if user role is 'cso'" do
        expect(subject).to permit(User.new(role: :cso), DefenceRequestControllerPolicy.new)
      end

    end
  end
end
