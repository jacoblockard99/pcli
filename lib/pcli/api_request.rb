# frozen_string_literal: true

module Pcli
  class ApiRequest
    def initialize(path)
      @path = path
      @method = 'get'
      @params = {}
      @headers = { 'Content-Type': 'application/json' }
    end

    def method(value = nil)
      if value
        @method = value
        self
      else
        @method
      end
    end

    def path(value = nil)
      if value
        @path = value
        self
      else
        @path
      end
    end

    def params(value = nil)
      if value
        @params = @params.merge(value)
        self
      else
        @params
      end
    end

    def param(key, value)
      @params[key] = value
      self
    end

    def headers(value = nil)
      if value
        @headers = @headers.merge(value)
        self
      else
        @headers
      end
    end

    def header(key, value)
      @headers[key] = value
      self
    end

    attr_writer :path, :method, :params, :headers
  end
end
