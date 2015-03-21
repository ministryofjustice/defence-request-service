class DefenceRequestForm < Paradat::Form

  underlying_model DefenceRequest

  delegates_fields :solicitor_type, :solicitor_name, :solicitor_firm, :phone_number, :detainee_name,
    :gender, :detainee_age, :allegations, :scheme, :custody_number, :comments, :feedback

  decorates_field :date_of_birth, DateField
  decorates_field :time_of_arrival, DateTimeField
  decorates_field :solicitor_time_of_arrival, DateTimeField
  decorates_field :interview_start_time, DateTimeField
  decorates_field :solicitor, SolicitorField
  decorates_field :appropriate_adult, AppropriateAdultField
end

# Ideas of usage
 #class DefenceRequestCreationForm < DefenceRequestForm
 #  allows_changes_to :solicitor_type, :solicitor_name, :solicitor_firm, :phone_number, :detainee_name,
 #    :gender, :detainee_age, :allegations, :scheme, :custody_number, :comments, :feedback

 #end

 #class DefenceRequestEditForm < DefenceRequestForm
 #  allows_change_to :solicitor_name, guard: -> { policy(self.base_model).solicitor_name_edit? }
 #end

 #class DefenceRequestSolicitorShow < DefenceRequestForm
 #  allows_changes_to :solicitor_arrival_time
 #end
