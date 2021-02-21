class ApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_not_found
  include Authenticable

  private
  def render_error(msg)

    render :json => {
        status: 'error',
        data: {},
        errors: msg
    }, status: 422
    # throw :halt, yield
    # raise "error"
    # throw(:abort)
    # raise Exception.new(msg)
    # redirect_back(fallback_location: root_path)
  end
  def record_not_found(exception)
    render_error(exception.message)
    Rails.logger.debug exception.message
  end
end
