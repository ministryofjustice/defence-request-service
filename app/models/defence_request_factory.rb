class DefenceRequestFactory
  def self.build(current_user)
    if current_user.organisation["type"] == "custody_suite"
      DefenceRequest.new(custody_suite_uid: current_user.organisation["uid"])
    end
  end
end