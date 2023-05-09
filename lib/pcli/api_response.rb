# frozen_string_literal: true

module Pcli
  class ApiResponse
    KnownError = Struct.new(:status, :type, :title, :message)

    attr_reader :code, :status, :body

    def initialize(code, success_status, status, body)
      @code = code
      @success_status = success_status
      @status = status
      @body = body
    end

    def json
      if @json.nil?
        begin
          @json = JSON.parse(body)
        rescue JSON::ParserError
          @json = false
        end
      end

      @json
    end

    def state
      @state ||= calculate_state
    end

    def success?
      state == :success
    end

    def known_error?
      state == :error
    end

    def unknown_error?
      state == :unknown_error
    end

    def failure?
      !success?
    end

    def error
      return @error unless @error.nil?

      return @error = false unless state == :error

      @error = KnownError.new(
        json['status'],
        json.dig('error', 'type'),
        json.dig('error', 'title'),
        json.dig('error', 'message')
      )
    end

    private

    def valid_error_schema
      Util::Hash.has_keys?(json, 'error', 'status') &&
        Util::Hash.has_keys?(json['error'], 'type', 'title', 'message')
    end

    def calculate_state
      return :invalid_response unless json

      if success_status
        :success
      elsif valid_error_schema
        :error
      else
        :unknown_error
      end
    end

    attr_reader :success_status
  end
end
