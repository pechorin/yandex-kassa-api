module YandexKassa
  class Api
    include Requests

    def initialize(params = {})
      @response_parser = params.fetch(:response_parser)
      @url = params.fetch(:url)
      @cert_file = params.fetch(:cert_file)
      @key_file = params.fetch(:key_file)
      @request_signer = params.fetch(:request_signer)
    end

    private

    attr_reader :cert_file, :key_file, :url, :response_parseri, :request_signer

    def post_signed_xml_request(yandex_kassa_request)
      signed_data = request_signer.sign(yandex_kassa_request.xml_request_body)
      response = client[yandex_kassa_request.request_path].post(signed_data)
      response_parser.parse(response)
    end

    def client
      @client ||= RestClient::Resource.new(
        url,
        ssl_client_cert: cert_file,
        ssl_client_key: key_file,
        verify_ssl: OpenSSL::SSL::VERIFY_NONE,
        headers: { content_type: 'application/pkcs7-mime'} )
    end
  end
end
