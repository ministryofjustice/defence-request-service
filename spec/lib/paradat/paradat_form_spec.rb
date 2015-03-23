require 'rails_helper'

RSpec.describe Paradat::Form do

  Temping.create :example_model do
    with_columns do |t|
      t.string :name
      t.integer :age, :weight
    end
  end

  class NameField < Paradat::Field
    def self.from_persisted_value value
      "I AM PERSISTED NAME VALUE"
    end
  end

  let(:example_model_instance) { ExampleModel.new }

  subject do
    Class.new Paradat::Form do
      underlying_model ExampleModel

      delegates_fields :weight, :age

      decorates_field :name, NameField
    end.new example_model_instance
  end

  context "underlying model" do
    specify 'can be accessed by singular name' do
      expect(subject.example_model).to eql example_model_instance
    end
  end

  context "decorated fields" do
    specify 'maps decorated field names to their persisted values' do
      expected_map =  { name: "I AM PERSISTED NAME VALUE" }
      expect(subject.decorated_fields).to eql expected_map
    end
  end

  context "submitting" do
    context "there are no errors" do
      specify "the base model is saved" do
        expect(example_model_instance).to receive(:save!)
        example_model_instance_params = { name: "Doesn't matter",
                                          age: "10",
                                          weight: "9000" }
        expect(subject.submit(example_model_instance_params)).to eql true
      end
    end
  end

end
