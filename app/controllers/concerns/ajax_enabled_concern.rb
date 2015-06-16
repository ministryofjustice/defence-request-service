module AjaxEnabledConcern
  def render_for_ajax_or_page(ajax_template, page_template)
    if request.xhr?
      render ajax_template, layout: false
    else
      render page_template
    end
  end

  def render_for_ajax_or_redirect(ajax_template, page_redirect, page_redirect_params = {})
    if request.xhr?
      render ajax_template, layout: false
    else
      redirect_to(page_redirect, page_redirect_params)
    end
  end
end