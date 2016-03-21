module YandexKassa
  class Api
    def initialize(params = {})
      @url = params.fetch(:url)
      @cert_file = params.fetch(:cert_file)
      @key_file = params.fetch(:key_file)
    end
  end

  private

  attr_reader :cert_file, :key_file, :url

  def client
    @client ||= RestClient::Resource.new(
      url,
      ssl_client_cert: cert_file,
      ssl_client_key: key_file,
      verify_ssl: OpenSSL::SSL::VERIFY_NONE,
      headers: { content_type: 'application/pkcs7-mime', content_lenght: '512' })
  end
end
