module YandexKassa
  class SignedResponseParser
    def initialize(params = {})
      cert_file = params.fetch(:cert_file)
      @cert_store = OpenSSL::X509::Store.new
      @cert_store.add_cert(cert_file)

      @deposit_cert_file = params.fetch(:deposit_cert_file)
    end

    def parse(data)
      signature = OpenSSL::PKCS7.new(data)
      signature.verify([deposit_cert_file], cert_store, nil, OpenSSL::PKCS7::NOVERIFY)
      signature.data
    end

    private

    attr_reader :cert_store, :deposit_cert_file
  end
end
