require 'rails_helper'

RSpec.describe DefenceRequest, "#generate_dscc_number!" do

  let!(:created_at_timestamp) { Time.now - 2.minutes }
  subject { 
    create :defence_request, :acknowledged, 
      created_at: created_at_timestamp,
      updated_at: created_at_timestamp 
  }

  def dscc_prefix_from_timestamp(timestamp)
    timestamp.strftime("%y%m")
  end

  it "sets the generated dscc_number as an attribute on the DefenceRequest" do
    subject.generate_dscc_number!
    expect(subject.dscc_number).to eq(DefenceRequest.last.dscc_number)
  end

  it "updates the updated_at timestamp on the DefenceRequest" do
    subject.generate_dscc_number!
    expect(subject.updated_at).to be_within(1.second).of(DefenceRequest.last.updated_at)
  end

  it "does not consider the generated dscc_number to be a dirty attribute" do
    subject.generate_dscc_number!
    expect(subject.changes).to be_empty
  end

  it "does not interfere with other dirty attributes of the DefenceRequest" do
    subject.detainee_name = "Bob Seaker"
    expect { subject.generate_dscc_number! }.not_to change(subject, :changes)
  end 

  context "with an existing dscc_number" do
    subject { create :defence_request, :acknowledged, :with_dscc_number, created_at: created_at_timestamp }
  
    it "does not generate a new number" do
      expect { subject.generate_dscc_number! }.not_to change(subject, :dscc_number)
    end
  end

  context "No Defence Requests in same month" do
    it "sets dscc_number to 'yymm00001Z'" do
      subject.generate_dscc_number!
      expect(subject.dscc_number).to eq("#{dscc_prefix_from_timestamp(created_at_timestamp)}00001Z")
    end
  end

  context "Defence Requests in the same month" do
    it "sets dscc_number to the number after the last dscc_number" do
      create :defence_request, :acknowledged, dscc_number: "#{dscc_prefix_from_timestamp(created_at_timestamp)}12344Z"
      subject.generate_dscc_number!
      expect(subject.dscc_number).to eq("#{dscc_prefix_from_timestamp(created_at_timestamp)}12345Z")
    end
  end

  context "Defence Request in same month with max number (yymm99999Z)" do
    it "sets dscc_number to the first number of following month" do
      create :defence_request, :acknowledged, dscc_number: "#{dscc_prefix_from_timestamp(created_at_timestamp)}99999Z"
      subject.generate_dscc_number!
      expect(subject.dscc_number).to eq("#{dscc_prefix_from_timestamp(created_at_timestamp + 1.month)}00000Z")
    end
  end
end
