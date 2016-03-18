require "yandex_kassa/version"
require "yandex_kassa/configuration"
require "yandex_kassa/requests"
require "openssl"
require "rest-client"

module YandexKassa
  class << self
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

    def client
      @client ||= RestClient::Resource.new(
        configuration.url,
        ssl_client_cert: cert_file,
        ssl_client_key: key_file,
        ssl_ca_file: deposit_cert_file,
        verify_ssl: OpenSSL::SSL::VERIFY_PEER,
        headers: { content_type: 'application/pkcs7-mime', content_lenght: '512' })
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
