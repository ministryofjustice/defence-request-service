class Mailer < ApplicationMailer
  default from: "<DSDS Notifications> noreply@#{Settings.action_mailer.smtp_settings.domain}"

  def notify_interview_start_change(defence_request, solicitor)
    @defence_request = defence_request
    mail(to: solicitor.email,
         subject: 'Interview start time change',
         content_type: 'text/html',
         importance: 'High'
        )
  end

  def send_solicitor_case_details(defence_request, solicitor)
    @defence_request = defence_request
    mail(to: solicitor.email,
         subject: 'Case Details',
         content_type: 'text/html',
         importance: 'High'
    )
  end
end
