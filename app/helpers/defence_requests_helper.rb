module DefenceRequestsHelper

  def solicitor_id solicitor_hash
    "solicitor-#{solicitor_hash['id']}"
  end

end
