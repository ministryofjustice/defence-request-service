require "rails_helper"

RSpec.describe DefenceRequestForm do

  let (:defence_request) { FactoryGirl.create(:defence_request) }
  subject { DefenceRequestForm.new FactoryGirl.create(:defence_request) }

  let (:params_for_dr)   { {  detainee_name: defence_request.detainee_name,
                              gender: defence_request.gender,
                              offences: defence_request.offences,
                              time_of_arrival: datetime_to_params(defence_request.time_of_arrival),
                              comments: defence_request.comments } }


  describe "submit" do
    context "with valid params" do
      it "returns true, and has no errors" do
        expect(subject.submit params_for_dr).to eql true
        expect(subject.errors).to be_blank
      end
    end

    context "with invalid params" do
      context "invalid attribute on the dr" do
        let(:invalid_params) { params_for_dr.merge({ gender: "" }) }

        it "adds any errors from the dr, to itself" do
          expect(subject.submit invalid_params).to eql false
          expect(subject.errors.count).to eql 1
          expect(subject.errors[:gender]).to contain_exactly("You must describe the detainee's gender or select 'Unspecified'")
        end
      end

      context "invalid field object" do
        context "that is has presence validated on the dr" do
          let(:invalid_params) { params_for_dr.merge({ time_of_arrival: invalid_time_of_arrival }) }
          context "blank" do
            let(:invalid_time_of_arrival) { { date: "",
                                              hour: "",
                                              min: "" } }
            let(:expected_error_message) {
              "You must give the detainee’s arrival time (eg 23 10) - please give hour, minutes and date (DD/MM/YYYY)"
            }

            it "adds errors from the field object to itself" do
              expect(subject.submit invalid_params).to eql false
              expect(subject.errors.count).to eql 1
              expect(subject.errors[:time_of_arrival]).to contain_exactly expected_error_message
            end
          end

          context "not blank" do
            let(:invalid_time_of_arrival) { { date: "I",
                                              hour: "BROKEN",
                                              min: "!" } }
            let(:expected_error_message) {
              "You must give the detainee’s arrival time (eg 23 10) - please give hour, minutes and date (DD/MM/YYYY)"
            }

            it "adds errors from the field object to itself" do
              expect(subject.submit invalid_params).to eql false
              expect(subject.errors.count).to eql 1
              expect(subject.errors[:time_of_arrival]).to contain_exactly expected_error_message
            end
          end
        end

        context "that does not have presence validated on the dr" do
          let(:invalid_params) { params_for_dr.merge({ interview_start_time: invalid_interview_start_time }) }

          context "blank" do
            let(:invalid_interview_start_time) { { date: "",
                                                   hour: "",
                                                   min: "" } }


            it "it does not add any errors to itself" do
              expect(subject.submit invalid_params).to eql true
              expect(subject.errors.count).to eql 0
            end
          end

          context "not blank" do
            let(:invalid_interview_start_time) { { date: "I",
                                                   hour: "BROKEN",
                                                   min: "!" } }
            let(:expected_error_message) {
              "Check that you’ve given a valid interview time (eg 23 10) - please give hour, minutes and date (DD/MM/YYYY)"
            }

            it "adds errors from the field object to itself" do
              expect(subject.submit invalid_params).to eql false
              expect(subject.errors.count).to eql 1
              expect(subject.errors[:interview_start_time]).to contain_exactly expected_error_message
            end
          end
        end
      end

    end
  end
end

def datetime_to_params(datetime)
  { date: datetime.to_date.to_s(:full),
    hour: datetime.hour.to_s,
    min: datetime.min.to_s }
end

def date_to_params(datetime)
  { year: datetime.year.to_s,
    month: datetime.month.to_s,
    day: datetime.day.to_s }
end
