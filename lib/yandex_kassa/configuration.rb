module YandexKassa
  class Configuration
    attr_accessor :url, :deposit, :cert, :key, :passphrase

    def cert_file
      @cert_file ||= OpenSSL::X509::Certificate.new(File.read(cert))
    end

    def key_file
      @key_file ||= OpenSSL::PKey::RSA.new(File.read(key), passphrase)
    end

    def deposit_cert_file
      @depostit_cert_file ||= OpenSSL::X509::Certificate.new(File.read(deposit))
    end
  end
end
