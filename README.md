[![Build Status](https://travis-ci.org/Malinskiy/stf-client.svg?branch=master)](https://travis-ci.org/Malinskiy/stf-client)
[![Gem](https://img.shields.io/gem/v/stf-client.svg)](https://rubygems.org/gems/stf-client)
[![Gem](https://img.shields.io/gem/dt/stf-client.svg)](https://rubygems.org/gems/stf-client)

# Smartdust CLI client
Automation client for connecting to Smartdust Lab devices via adb from cli.
![smartdust-logo-text-2021.png](smartdust-logo-text-2021.png)
Designed with the following scenario in mind:

1. Connect to remote devices
2. Do something with the device via adb (Instrumentation Test, adb install, etc)
3. Disconnect from device

Due to it being a console tool, it's very easy to use  it for test automation in a CI\CD pipeline, for example in Jenkins.

Allows for filtering by any device description parameter
as well as listing all available values of a given parameter
e.g. all unique names of devices in the lab instance.

## Installation from source
## Prequisities

- Ruby along with RubyGems installed - versions higher than 3.0.2 are not guaranteed to work
- This repository cloned

## Installation
- Enter the directory where the repository is cloned
- adding "sudo" before the following commands might be needed:
- ```gem build smartdust-client.gemspec```
- ```gem install smartdust-client-1.0.0.gem``` (or different version, see output of the previous command)

- Run it by simply entering ```smartdust-client``` 

## Usage

```
NAME
    stf-client - Smartphone Test Lab client

SYNOPSIS
    stf-client [global options] command [command options] [arguments...]

GLOBAL OPTIONS
    --help             - Show this message
    -t, --token=arg    - Authorization token, can also be set by environment variable STF_TOKEN (default: none)
    -u, --url=arg      - URL to STF, can also be set by environment variable STF_URL (default: none)
    -v, --[no-]verbose - Be verbose

COMMANDS
    clean      - Frees all devices that are assigned to current user in STF. Doesn't modify local adb
    connect    - Search for a device available in STF and attach it to local adb server
    disconnect - Disconnect device(s) from local adb server and remove device(s) from user devices in STF
    help       - Shows a list of commands or help for one command
    keys       - Show available keys for filtering
    values     - Show known values for the filtering key
    
ENVIRONMENT VARIABLES
    STF_TOKEN - Authorization token 
    STF_URL   - URL to STF 
```
- Authorization token can be obtained from the Smartdust Lab web interface in Settings -> Keys
- When connecting with this tool for the first time, have the Smartdust Lab web interface open
to accept adding a new ADB key. This is necessary for every new machine that hasn't connected 
yet to Remote Debug on a given Lab instance.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
