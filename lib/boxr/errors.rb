module Boxr

  class BoxrError < StandardError

    attr_reader :response_body, :type, :status, :code, :help_uri, :box_message, :boxr_message, :request_id

    def initialize(status: nil, body: nil, header: nil, boxr_message: nil)
      @status = status
      @response_body = body
      @header = header
      @boxr_message = boxr_message

      if(body)
        begin
          body_json = MultiJson.load(body) unless body.empty?

          if body_json
            @type = body_json["type"]
            @box_status = body_json["status"]
            @code = body_json["code"]
            @help_uri = body_json["help_uri"]
            @box_message = body_json["message"]
            @request_id = body_json["request_id"]
          end
        rescue
        end
      end
    end

    def message
      auth_header = @header['WWW-Authenticate'][0] unless @header.nil?
      if(auth_header && auth_header != [])
        "#{@status}: #{auth_header}"
      elsif(@box_message)
        "#{@status}: #{@box_message}"
      elsif(@boxr_message)
        @boxr_message
      else
        "#{@status}: #{@response_body}"
      end
    end

    def to_s
      message
    end
  end

end
