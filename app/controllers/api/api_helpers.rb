module API
  module ApiHelpers

    private

    def check_content_type
      if request.method == 'POST' || request.method == 'PATCH'
        unless request.content_type and request.content_type.include?('application/json')
          render_api_error(400,  "Only content type application/json is accepted.
                                              Your content type: #{request.content_type}")
        end
      end
    end

    def render_api_error(status_code,  message = nil)
      response_data = {success: false, error: {message: message}}
      render json: response_data, status: status_code
    end

  end
end