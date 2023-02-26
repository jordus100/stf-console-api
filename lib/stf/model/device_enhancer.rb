module Stf
  class DeviceEnhancer
    def get_tunneled_remote_connect_url(device)
      provider = device.provider
      provider_ip = provider["ip"]
      result = DI[:stf].start_debug device.serial
      remote_connect_url_split = result.remoteConnectUrl.split ":"
      remote_connect_port = remote_connect_url_split[1]
      result = DI[:stf].check_tunnel provider_ip, remote_connect_port
      if result.success
        remote_connect_hostname = remote_connect_url_split[0]
        remote_connect_hostname + ":" + result.port.to_s
      else nil
      end
    end
  end
end