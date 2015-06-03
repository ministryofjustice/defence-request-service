class PingResponse
  VERSION_FILE = "/.version"

  UNKNOWN_VERSION_DATA_RESPONSE = {
    version_number: "unknown",
    build_date: nil,
    commit_id: "unknown",
    build_tag: "unknown"
  }

  def self.data
    YAML.load_file(VERSION_FILE)
  rescue
    UNKNOWN_VERSION_DATA_RESPONSE
  end
end
