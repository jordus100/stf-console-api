require 'di'
require 'ADB'

require 'stf/client'
require 'stf/log/log'

module Stf
  class StartOneDebugSessionInteractor

    include Log
    include ADB

    def execute(device)
      return false if device.nil?
      serial = device.serial

      begin
        success = DI[:stf].add_device serial
        if success
          logger.info "Device added #{serial}"
        else
          logger.error "Can't add device #{serial}"
          raise
        end

        result = DI[:stf].start_debug serial
        if result.success
          logger.info "Debug started #{serial}"
        else
          logger.error "Can't start debugging session for device #{serial}"
          raise
        end

        provider = device.getValue "provider"
        provider_ip = provider["ip"]
        remote_connect_url_split = result.remoteConnectUrl.split ":"
        remote_connect_port = remote_connect_url_split[1]
        result = DI[:stf].open_tunnel provider_ip, remote_connect_port.to_i
        if result.success
          logger.info "Opened tunnel to provider with IP #{provider_ip}"
        else
          logger.error "Can't open tunnel to provider with IP #{provider_ip}"
          raise
        end
        remote_connect_tunneled_url = DI[:device_enhancer].get_tunneled_remote_connect_url(device)
        logger.info remote_connect_tunneled_url
        execute_adb_with 30, "connect #{remote_connect_tunneled_url}"

        shell('echo adbtest', {serial: "#{remote_connect_tunneled_url}"}, 30)
        raise ADBError, "Could not execute shell test" unless stdout_contains "adbtest"

        return true

      rescue StandardError, SignalException => e
        begin
          # we will try clean anyway
          DI[:stf].remove_device serial
          if test ?d, '/custom-metrics'
            File.open('/custom-metrics/openstf_connect_fail', 'a') do |f|
              message = (!e.nil? || !e.message.nil?) ? e.message : ""
              f.write("openstf_connect_fail,reason=\"#{escape(message)}\",serial=\"#{escape(serial)}\" count=1i #{Time.now.to_i}\n")
            end
          end
        rescue
        end

        logger.error "Failed to connect to #{serial}: " + e&.message
        return false
      end
    end

    def escape(s)
      s.gsub(/["]/, '\"').gsub(/[ ]/, '\ ').gsub(/[=]/, '\=').gsub(/[,]/, '\,')
    end
  end
end