module YandexKassa
  class RequestSigner
    def initialize(params = {})
      @cert_file = params.fetch(:cert_file)
      @key_file = params.fetch(:key_file)
    end

    def sign(raw_xml_body)
      OpenSSL::PKCS7.sign(cert_file, key_file, raw_xml_body, [], OpenSSL::PKCS7::NOCERTS).to_pem
    end

    private

    attr_reader :cert_file, :key_file
  end
end
