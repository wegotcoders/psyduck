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

    def initialize(ip_address, username = 'anonymous', password = nil, command_port = 21, passivity = true, options = {})
      @ip_address = ip_address
      @username = username
      @password = password
      @command_port = command_port
      @ftp = Net::FTP.new
      @ftp.passive = passivity
      @ftp.resume = true
      @ftp.debug_mode = options[:debug_mode]
    end

    def ftp
      @ftp
    end

    def connect
      @ftp.connect(@ip_address, @command_port)
    end

    def login
      @ftp.login(@username, @password)
    end

    def upload_file_to_server(path_to_local_file, path_to_remote_directory)
      file = File.open(path_to_local_file)
      @ftp.put(file)
    end
  end
end
