require_relative "../sections/defence_request"

class SolicitorDashboardPage < SitePrism::Page
  sections :defence_requests, DefenceRequestSection, "section.defence-requests .defence-request-box"
end