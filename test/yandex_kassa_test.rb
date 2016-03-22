require 'test_helper'

class YandexKassaTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::YandexKassa::VERSION
  end

  def test_it_configurates
    YandexKassa.configure do |config|
      config.url = 'test.url:9090'
      config.deposit = 'deposit.cer'
      config.key = 'private.key'
      config.cert = 'my.cer'
    end

    assert_equal YandexKassa.configuration.url, 'test.url:9090'
  end

  def test_it_initializes_client
    def YandexKassa.cert_file; "file_stub"; end
    def YandexKassa.key_file; "file_stub"; end
    def YandexKassa.deposit; "file_stub"; end
    def YandexKassa.pkcs7_response_parser; DummyResponseParser.new; end

    assert_kind_of(YandexKassa::Api, YandexKassa.create)
  end
end

class DummyRestResource
  def post(body)
    "post_response"
  end
end

class DummyApi
  include YandexKassa::Requests

  def client
    Hash.new { DummyRestResource.new }
  end

  def response_parser
    @response_parser = DummyResponseParser.new
  end
end

class DummyResponseParser
  def parse(arg)
    arg
  end
end

class RequestsTest < Minitest::Test
  def test_test_deposition_request_body_has_right_attributes
    expected = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<testDepositionRequest agentId="123"
clientOrderId="12345"
requestDT="2011-07-01T20:38:00.000Z"
dstAccount="410011234567"
amount="10.00"
currency="643"
contract="contract"/>
</testDepositionRequest>
XML
    test_deposition_xml = YandexKassa::Requests::TestDeposition.new do |request|
      request.agent_id = 123
      request.client_order_id = 12345
      request.request_dt = "2011-07-01T20:38:00.000Z"
      request.amount = "10.00"
      request.currency = 643
      request.contract = "contract"
      request.dst_account = "410011234567"
    end

    assert_equal expected, test_deposition_xml.xml_request_body
  end

  def test_make_depo
    expected = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<makeDepositionRequest agentId="123"
clientOrderId="12345"
requestDT="2011-07-01T20:38:00.000Z"
dstAccount="410011234567"
amount="10.00"
currency="643"
contract="contract"/>
<paymentParams>
<smsPhoneNumber>123123</smsPhoneNumber>
<pdr_city>City</pdr_city>
</paymentParams>
</makeDepositionRequest>
XML
    make_deposition = YandexKassa::Requests::MakeDeposition.new do |make_deposition|
      make_deposition.agent_id = 123
      make_deposition.client_order_id = 12345
      make_deposition.request_dt = "2011-07-01T20:38:00.000Z"
      make_deposition.amount = "10.00"
      make_deposition.currency = 643
      make_deposition.contract = "contract"
      make_deposition.dst_account = "410011234567"
      make_deposition.set_payment_params("smsPhoneNumber" => "123123", "pdr_city" => "City")
    end

    assert_equal expected, make_deposition.xml_request_body
  end

  def test_it_allows_to_send_test_deposition_request
    assert_equal DummyApi.new.test_deposition, DummyRestResource.new.post("body")
  end

  def test_it_allow_to_send_make_deposition_request
    request = DummyApi.new.make_deposition do |request|
      request.set_payment_params
    end

    assert_equal request, DummyRestResource.new.post("body")
  end
end
