require "spec_helper"
require "tempfile"
require "pry"
require_relative "../../lib/ping_response"

RSpec.describe PingResponse do

  let(:valid_version_file_content) {
    { version_number: "1.23", build_date: Time.now, commit_id: "irrelevant sha", build_tag: "irrelevant build tag" }
  }

  let(:unknown_version_response) {
    { version_number: "unknown", build_date: nil, commit_id: "unknown", build_tag: "unknown" }
  }

  describe "#data" do
    context "with an error loading the data file" do
      it "returns an unknown_version_response" do
        expect(YAML).to receive(:load_file).and_raise(StandardError)

        expect(described_class.data).to eq(unknown_version_response)
      end
    end

    context "with a valid version file" do
      let!(:overridden_version_file) do
        filehandle = Tempfile.new("ping_response")

        filehandle.write(valid_version_file_content.to_yaml)
        filehandle.close

        filehandle.path
      end

      it "should return a valid response" do
        stub_const("PingResponse::VERSION_FILE", overridden_version_file)

        expect(described_class.data).to eq(valid_version_file_content)
      end
    end
  end
end
