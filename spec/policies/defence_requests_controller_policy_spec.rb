require 'rails_helper'

RSpec.describe DefenceRequestsControllerPolicy do
  subject { DefenceRequestsControllerPolicy }

  [:index?, :new?, :create?, :refresh_dashboard?, :edit?, :update?].each do |action|
    permissions action do
      it "grants access to #{action} user role is 'cso'" do
        expect(subject).to permit(User.new(role: :cso), DefenceRequestsController)
      end
    end
  end

  [:index?, :refresh_dashboard?].each do |action|
    permissions action do
      it "grants access to #{action} user role is 'cco'" do
        expect(subject).to permit(User.new(role: :cco), DefenceRequestsController)
      end
    end
  end

  [:index?].each do |action|
    permissions action do
      it "grants access to #{action} user role is 'solicitor'" do
        expect(subject).to permit(User.new(role: :solicitor), DefenceRequestsController)
      end
    end
  end

end
