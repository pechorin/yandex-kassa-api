require "yandex_kassa/version"
require "yandex_kassa/configuration"
require "yandex_kassa/requests"
require "rest-client"

module YandexKassa
  class << self
    def configure(&block)
      block.call(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def client
      @client ||= RestClient::Resource.new(configuration.url, headers: { content_type: 'application/pkcs7-mime', content_lenght: '512' })
    end
  end
end
