class DefenceRequestForm
  include ActiveModel::Model

  def self.model_name
    ActiveModel::Name.new(self, nil, 'DefenceRequest')
  end

  def initialize(defence_request)
    @defence_request = defence_request
    @date_of_birth = DateHandler.from_date(defence_request.date_of_birth)
    @time_of_arrival = DateTimeHandler.from_date_time(defence_request.time_of_arrival)
    @to_validate = [defence_request, @date_of_birth_thing, @time_of_arrival]
  end

  delegate :solicitor_type, :solicitor_name, :solicitor_firm, :phone_number, :detainee_name,
           :gender, :detainee_age, :allegations, :scheme, :custody_number, :comments, :feedback,
           to: :defence_request

  def submit(params)
    defence_request.attributes = params.slice(:solicitor_type, :solicitor_name, :solicitor_firm, :phone_number,
                                              :detainee_name, :gender, :detainee_age, :allegations, :scheme,
                                              :custody_number, :comments)
    # self.solicitor_email = params[:solicitor_email]
    # self.appropriate_adult_required = params[:appropriate_adult_required]
    # self.time_of_arrival = params[:time_of_arrival]
    # self.solicitor_time_of_arrival = params[:solicitor_time_of_arrival]
    # self.interview_start_time = params[:interview_start_time]
    defence_request.attributes[:date_of_birth] = @date_of_birth.value
    defence_request.attributes[:time_of_arrival] = @time_of_arrival.value

    if @to_validate.all?(&:valid?)
      defence_request.save!
      true
    else
      @to_validate.select(&:invalid?).each do |invalid_thing|
        self.errors.add  invalid_thing.errors
      end
      false
    end
  end

  def defence_request
    @defence_request
  end

  # def solicitor_email=(email)
  #   defence_request.solicitor_id = User.solicitors.find_by_email email
  # end
  #
  # def solicitor_email
  #   #TODO
  #   # User.find(defence_request.solicitor_id).email
  #   User.first
  # end
  #
  # def appropriate_adult_required=(checkbox)
  #   defence_request.appropriate_adult = 'yes' if checkbox == '1'
  # end
  #
  # def appropriate_adult_required
  #   defence_request.appropriate_adult
  # end
  #
  #
  # def solicitor_time_of_arrival=(new_date_and_time)
  #   @solicitor_time_of_arrival_builder = DateTimeBuilder.new(new_date_and_time)
  #
  #   if @solicitor_time_of_arrival_builder.valid?
  #     defence_request.solicitor_time_of_arrival = @solicitor_time_of_arrival_builder.value
  #   end
  # end
  #
  # def solicitor_time_of_arrival
  #   if @solicitor_time_of_arrival_builder
  #     @solicitor_time_of_arrival_builder
  #   else
  #     defence_request.solicitor_time_of_arrival
  #   end
  # end
  #
  # def interview_start_time=(new_date_and_time)
  #   @interview_start_time_builder = DateTimeBuilder.new(new_date_and_time)
  #
  #   if @interview_start_time_builder.valid?
  #     defence_request.interview_start_time = @interview_start_time_builder.value
  #   end
  # end
  #
  # def interview_start_time
  #   if @interview_start_time_builder
  #     @interview_start_time_builder
  #   else
  #     defence_request.interview_start_time
  #   end
  # end
end


#TODO: remove adult from model
# delegate
#          :date_of_birth,  :time_of_arrival, :appropriate_adult,
#          :created_at, :updated_at, :state, :dscc_number,  :interview_start_time, :solicitor_id,
#          :cco_id, :solicitor_time_of_arrival, to: :defence_request
