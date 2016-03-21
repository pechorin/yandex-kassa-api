require "yandex_kassa/version"
require "yandex_kassa/configuration"
require "yandex_kassa/requests"
require "yandex_kassa/api"
require "openssl"
require "rest-client"

module YandexKassa
  class << self

    def create
      Api.new(url: configuration.url, cert_file: cert_file, key_file: key_file)
    end

    def configure(&block)
      block.call(configuration)
    end

    def test_deposition(params = {})
      test_deposition_request = Requests::TestDeposition.new
      params.each { |method, value| test_deposition_xml.instance_variable_set("@#{method}", value) }
      client["testDeposition"].post(test_deposition_request.xml_request_body)
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
      @depostit_cert_file ||=OpenSSL::X509::Certificate.new(File.read(configuration.deposit))
    end
  end
end
