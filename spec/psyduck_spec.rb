require_relative 'spec_helper'

class PsyduckTest < Minitest::Test
  describe Psyduck do
    it 'must have a version number' do
      ::Psyduck::VERSION.wont_be_nil
    end
  end

  describe Psyduck::FTPClient do
    before do
      @server = FakeFtp::Server.new(21212, 21213)
      @server.start
      @ftp_client = Psyduck::FTPClient.new('127.0.0.1', 'username', 'password', 21212)
    end

    after do
      @server.stop
    end

    describe 'The FTP client' do
      it 'must take an IP address or hostname as the first argument' do
        @ftp_client.ip_address.wont_be_empty
      end

      it "must take a username as the second argument (defaults to 'anonymous')" do
        @ftp_client.username.wont_be_empty
      end

      it 'may take a password as the third argument (defaults to nil)' do
        @ftp_client.password.wont_be_empty
      end

      it 'may optionally override the default command port number' do
        @ftp_client.command_port.must_equal 21212
      end

      it 'may run in active or passive mode (defaults to passive)' do
        @ftp_client.passivity.must_equal true
      end

      describe 'Upload process' do
        before do
          @ftp_client.upload_file_to_server('spec/fixtures/file_for_test_upload.txt')
        end

        it 'must uplaod the file to the FTP server' do
          @server.files.must_include('file_for_test_upload.txt')
        end

        it 'must not lose any data' do
          #newline byte is ignored by file method
          @server.file('file_for_test_upload.txt').bytes.must_equal 20
        end

        it 'must resume if interrupted' do
          @ftp_client.resumable.must_equal true
        end
      end
    end
  end
end
