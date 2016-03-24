module YandexKassa
  class StoreCard
    def initialize(params = {})
      @url = url
      @error_url = params.fetch(:error_url)
      @success_url = params.fetch(:success_url)
      @response_format = params.fetch(:response_format)
      @card_number = params.fetch(:card_number)
    end

    def request
      @request ||= RestClient.post(url, request_params)
    end

    private

    attr_reader :error_url, :success_url, :response_format, :destination_card_number

    def request_params
      {
        "skr_destinationCardNumber" => destination_card_number,
        "skr_responseFormat" => response_format,
        "skr_successUrl" => success_url,
        "skr_errorUrl" => error_url
      }
    end
  end
end
