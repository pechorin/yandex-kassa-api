module YandexKassa
  module Requests
    def test_deposition(params = {}, &block)
      test_deposition_request = TestDeposition.new(params, &block)
      post_signed_xml_request(test_deposition_request)
    end

    def make_deposition(params = {}, &block)
      make_deposition_request = MakeDeposition.new(params, &block)
      post_signed_xml_request(make_deposition_request)
    end

    def balance(parmas = {}, &block)
      balance_request = Balance.new(parmas, &block)
      post_signed_xml_request(balance_request)
    end

    class Deposition

      attr_accessor :agent_id, :client_order_id, :request_dt, :dst_account, :amount, :currency, :contract

      def initialize(params = {}, &block)
        params.each { |method, value| instance_variable_set("@#{method}", value) }
        block.call(self) if block_given?
      end

      def request_name; end

      def request_path; end

      def extra_params; end

      def xml_request_body
<<XML
<?xml version="1.0" encoding="UTF-8"?>
<#{request_name} agentId="#{agent_id}"
clientOrderId="#{client_order_id}"
requestDT="#{request_dt}"
dstAccount="#{dst_account}"
amount="#{amount}"
currency="#{currency}"
contract="#{contract}">#{extra_params}
</#{request_name}>
XML
      end
    end

    class TestDeposition < Deposition
      def request_name
        'testDepositionRequest'
      end

      def request_path
        'testDeposition'
      end
    end

    class MakeDeposition < Deposition
      def request_name
        'makeDepositionRequest'
      end

      def request_path
        'makeDeposition'
      end

      def extra_params
        @payment_params_body || set_payment_params
      end

      def payment_params
        @payment_params ||= {}
      end

      def set_payment_params(params = payment_params)
        params = params.inject("") { |str, hash| str += "<#{hash[0]}>#{hash[1]}</#{hash[0]}>\n"}
        @payment_params_body = "\n<paymentParams>\n#{params}</paymentParams>"
      end
    end

    class Balance < Deposition
      def request_name
        'balanceRequest'
      end

      def request_path
        'balance'
      end

      def xml_request_body
<<XML
<?xml version="1.0" encoding="UTF-8"?>
<#{request_name} agentId="#{agent_id}"
clientOrderId="#{client_order_id}"
requestDT="#{request_dt}"/>
XML
      end
    end
  end
end
