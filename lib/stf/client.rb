require 'net/http'
require 'json'
require 'ostruct'

require 'stf/version'
require 'stf/log/log'

module Stf
  class Client
    include Log

    def initialize(base_url, token)
      @base_url = base_url
      @token    = token
    end

    def get_devices
      response = execute '/api/v1/devices', Net::HTTP::Get
      return response.devices
    end

    def get_device(serial)
      response = execute "/api/v1/devices/#{serial}", Net::HTTP::Get
      return response.device
    end

    def get_user
      response = execute '/api/v1/user', Net::HTTP::Get
      return response.user
    end

    def get_user_devices
      response = execute '/api/v1/user/devices', Net::HTTP::Get
      return response.devices
    end

    def add_device(serial)
      response = execute '/api/v1/user/devices', Net::HTTP::Post, {serial: serial}.to_json
      return response.success
    end

    def remove_device(serial)
      response = execute "/api/v1/user/devices/#{serial}", Net::HTTP::Delete
      return response.success
    end

    def start_debug(serial)
      response = execute "/api/v1/user/devices/#{serial}/remoteConnect", Net::HTTP::Post
      return response
    end

    def open_tunnel(provider_ip, port)
      response = execute "/api/v1/tunnel", Net::HTTP::Post, {ipAddress: provider_ip, port: port}.to_json
      return response
    end

    def destroy_tunnel(ip, port)
      response = execute "/api/v1/tunnel", Net::HTTP::Delete, {ipAddress: ip, port: port}.to_json
      return response.success
    end

    def stop_debug(serial)
      response = execute "/api/v1/user/devices/#{serial}/remoteConnect", Net::HTTP::Delete
      return response.success
    end

    def check_tunnel(provider_ip, port)
      response = execute "/api/v1/tunnel/#{provider_ip}/#{port}", Net::HTTP::Get
      return response
    end

    def add_adb_public_key(adb_public_key)
      response = execute '/api/v1/user/adbPublicKeys', Net::HTTP::Post, {publickey: adb_public_key }.to_json
      return response.success
    end

    private

    def execute(relative_url, type, body='')
      return execute_absolute @base_url + relative_url, type, body
    end

    def execute_absolute(url, type, body='', limit = 10)
      raise ArgumentError, 'too many HTTP redirects' if limit == 0

      uri          = URI.parse(url)
      http         = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      request      = type.new(uri, 'Authorization' => "Bearer #{@token}", 'Content-Type' => 'application/json')
      request.body = body
      response     = http.request(request)

      case response
        when Net::HTTPSuccess then
          json = JSON.parse(response.body, object_class: OpenStruct)

          logger.debug "API returned #{json}"
        when Net::HTTPRedirection then
          location = response['location']
          logger.debug "redirected to #{location}"
          return execute_absolute(location, type, body, limit - 1)
        else
          logger.error "API returned #{response.value}"
      end

      return json
    end
  end
end