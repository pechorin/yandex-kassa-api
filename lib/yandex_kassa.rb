require "yandex_kassa/version"
require "yandex_kassa/configuration"
require "yandex_kassa/requests"
require "yandex_kassa/api"
require "yandex_kassa/signed_response_parser"
require "yandex_kassa/request_signer"
require "openssl"
require "rest-client"

module YandexKassa
  class << self
    def create
      Api.new(url: configuration.url,
              cert_file: configuration.cert_file,
              key_file: configuration.key_file,
              response_parser: pkcs7_response_parser,
              request_signer: request_signer)
    end

    def configure(&block)
      block.call(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def pkcs7_response_parser
      @pkcs7_response_parser ||= SignedResponseParser.new(
        deposit_cert_file: configuration.deposit_cert_file,
        cert_file: configuration.cert_file)
    end

    def request_signer
      @request_signer ||= RequestSigner.new(cert_file: configuration.cert_file, key_file: configuration.key_file)
    end
  end
end
