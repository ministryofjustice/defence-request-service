require_relative "../../app/models/defence_request_transition"

RSpec.describe DefenceRequestTransition, "#complete" do
  context "transitioning to accepted" do
    it "transitions the given model to accepted state" do
      defence_request = spy(:defence_request)
      transition_to = "accept"
      user = double(:user)

      DefenceRequestTransition.new(defence_request, transition_to, user).complete

      expect(defence_request).to have_received(:accept)
      expect(defence_request).to have_received(:save!)
    end
  end

  context "transitioning to acknowledged" do
    it "transitions the given model to accepted state" do
      defence_request = spy(:defence_request)
      transition_to = "acknowledge"
      user = double(:user)

      DefenceRequestTransition.new(defence_request, transition_to, user).complete

      expect(defence_request).to have_received(:cco=).with(user)
      expect(defence_request).to have_received(:acknowledge)
      expect(defence_request).to have_received(:save!)
    end
  end

  context "transitioning to queue" do
    it "transitions the given model to accepted state" do
      defence_request = spy(:defence_request)
      transition_to = "queue"
      user = double(:user)

      DefenceRequestTransition.new(defence_request, transition_to, user).complete

      expect(defence_request).to have_received(:queue)
      expect(defence_request).to have_received(:save!)
    end
  end

  context "failing transition" do
    it "returns false" do
      defence_request = spy(:defence_request)
      transition_to = "queue"
      user = double(:user)

      allow(defence_request).to receive(:queue).and_return(false)
      transition = DefenceRequestTransition.new(
        defence_request,
        transition_to,
        user
      )

      expect(transition.complete).to eq false
    end
  end
end
