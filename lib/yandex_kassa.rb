require "yandex_kassa/version"
require "yandex_kassa/configuration"
require "yandex_kassa/requests"
require "yandex_kassa/api"
require "yandex_kassa/signed_response_parser"
require "openssl"
require "rest-client"

module YandexKassa
  class << self

    def create
      Api.new(url: configuration.url, cert_file: cert_file,
                key_file: key_file, response_parser: pkcs7_response_parser)
    end

    def configure(&block)
      block.call(configuration)
    end

    def pkcs7_response_parser
      @pkcs7_response_parser ||= SignedResponseParser.new(deposit_cert_file: deposit_cert_file,
                                                                           cert_file: cert_file)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def cert_file
      @cert_file ||= OpenSSL::X509::Certificate.new(File.read(configuration.cert))
    end

    def key_file
      @key_file ||= OpenSSL::PKey::RSA.new(File.read(configuration.key), configuration.passphrase)
    end

    def deposit_cert_file
      @depostit_cert_file ||= OpenSSL::X509::Certificate.new(File.read(configuration.deposit))
    end
  end
end
