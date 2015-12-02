require 'psyduck/version'
require 'net/ftp'

module Psyduck
  class FTPClient
    # attr_readers are needed for tests
    attr_reader :ip_address
    attr_reader :username
    attr_reader :password
    attr_reader :command_port
    attr_reader :passivity
    attr_reader :resumable

    def initialize(ip_address, username = 'anonymous', password = nil, command_port = 21, passivity = true)
      @ip_address = ip_address
      @username = username
      @password = password
      @command_port = command_port
      @passivity = passivity
      @resumable = true
    end

    def upload_file_to_server(path_to_file)
      file = File.open(path_to_file)
      ftp = Net::FTP.new
      ftp.connect(@ip_address, @command_port)
      ftp.login(@username, @password)
      ftp.passive = true
      ftp.resume = @resumable
      ftp.put(file)
      ftp.close
    end
  end
end
