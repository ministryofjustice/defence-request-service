module DefenceRequestsHelper

  def solicitor_id solicitor_hash
    "solicitor-#{solicitor_hash['id']}"
  end

  def solicitor_schemes
    DefenceRequest::SCHEMES.map { |e| [e,e] }
  end

end
