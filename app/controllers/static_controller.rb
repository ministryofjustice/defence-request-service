class StaticController < ApplicationController
  protect_from_forgery except: :expired

  def help
    @page_title = 'Help'
    render 'help'
  end
  def accessibility
    @page_title = 'Accessibility'
    render 'accessibility'
  end
  def cookies
    @page_title = 'Cookies'
    render 'cookies'
  end
  def expired
    @page_title = 'Session expired'
    render 'expired'
  end
  def terms
    @page_title = 'Terms and conditions and privacy policy'
    render 'terms'
  end
end