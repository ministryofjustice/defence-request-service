class StatusController < ApplicationController
  skip_before_filter :authenticate_user!

  def index
    respond_to do |format|
      format.json { render json: {"status" => "OK"} }
      format.xml { render xml: {"Status" => "OK"}.to_xml(root: "Response") }
      format.any { render text: "OK"}
    end
  end
end
