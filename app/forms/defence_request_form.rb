class DefenceRequestForm
  include ActiveModel::Model

  def self.model_name
    ActiveModel::Name.new(self, nil, 'DefenceRequest')
  end

  def initialize(defence_request)
    @defence_request = defence_request
    @date_of_birth_handler = DateHandler.from_date(@defence_request.date_of_birth)
    @time_of_arrival_handler = DateTimeHandler.from_date_time(@defence_request.time_of_arrival)
    @solicitor_time_of_arrival_handler = DateTimeHandler.from_date_time(@defence_request.solicitor_time_of_arrival)
    @interview_start_time_handler = DateTimeHandler.from_date_time(@defence_request.interview_start_time)
    @solicitor_association_handler = SolicitorAssociationHandler.from_solicitor_id
    @appropriate_adult_handler = AppropriateAdultHandler.from_value(@defence_request.appropriate_adult)

    @to_validate = [  @defence_request,
                     @date_of_birth_handler,
                     @time_of_arrival_handler,
                     @solicitor_time_of_arrival_handler,
                     @interview_start_time_handler,
                     @solicitor_association_handler ]
  end

  delegate :solicitor_type, :solicitor_name, :solicitor_firm, :phone_number, :detainee_name,
           :gender, :detainee_age, :allegations, :scheme, :custody_number, :comments, :feedback,
           to: :defence_request

  def submit(params)
    @defence_request.attributes = params.slice(:solicitor_type, :solicitor_name, :solicitor_firm, :phone_number,
                                               :detainee_name, :gender, :detainee_age, :allegations, :scheme,
                                               :custody_number, :comments)

    @defence_request.attributes[:date_of_birth] = @date_of_birth_handler.value
    @defence_request.attributes[:time_of_arrival] = @time_of_arrival_handler.value
    @defence_request.attributes[:solicitor_time_of_arrival] = @solicitor_time_of_arrival_handler.value
    @defence_request.attributes[:interview_start_time] = @interview_start_time_handler.value
    @defence_request.attributes[:solicitor_id] = @solicitor_association_handler.value
    @defence_request.attributes[:appropriate_adult] = @appropriate_adult_handler.value(params[:appropriate_adult])

    if @to_validate.all?(&:valid?)
      @defence_request.save!
      true
    else
      @to_validate.select(&:invalid?).each do |invalid_thing|
        self.errors[invalid_thing.to_s] = invalid_thing.errors.messages
      end
      false
    end
  end

  def defence_request
    @defence_request
  end
end


#TODO: remove adult from model
# delegate
#          :date_of_birth,  :time_of_arrival, :appropriate_adult,
#          :created_at, :updated_at, :state, :dscc_number,  :interview_start_time, :solicitor_id,
#          :cco_id, :solicitor_time_of_arrival, to: :defence_request
