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
      @ftp_client = Psyduck::FTPClient.new(
        ip_address: '127.0.0.1',
        username: 'username',
        password: 'password',
        command_port: 21212)
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
        @ftp_client.ftp.passive.must_equal true
      end

      it 'must expose a Net::FTP object' do
        @ftp_client.ftp.class.must_equal Net::FTP
      end

      describe 'Session facility' do
        it 'must be able to establish and close a connection with the remote host' do
          @ftp_client.connect
          @server.connection.wont_be_nil

          @ftp_client.ftp.close
          @ftp_client.ftp.closed?.must_equal true
        end

        #fake_ftp does not currently provide the functionality to create test accounts
        #however something along the following lines might be desirable...

        # it 'will raise an error if unable to authenticate with the remote host' do
        #   @ftp_client = Psyduck::FTPClient.new('127.0.0.1', 'username', 'bad-password', 21212)
        #   @ftp_client.connect

        #   proc { @ftp_client.login }.must_raise Net::FTPPermError
        # end
      end

      describe 'Upload process' do
        before do
          @ftp_client.connect
          @ftp_client.login
          @ftp_client.ftp.mkdir('/pub/test_dir')
          @ftp_client.upload_file_to_server('spec/fixtures/file_for_test_upload.txt', '/pub/test_dir')
        end

        it 'must upload the complete file to a specific remote directory' do
          @ftp_client.ftp.chdir('/pub/test_dir')
          @ftp_client.ftp.list.last.must_match(/file_for_test_upload.txt/)
          @server.file('file_for_test_upload.txt').bytes.must_equal 20
        end

        it 'must resume if interrupted' do
          @ftp_client.ftp.resume.must_equal true
        end
      end
    end
  end
end
