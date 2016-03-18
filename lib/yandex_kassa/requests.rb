module YandexKassa
  module Requests
    class Deposition
      attr_accessor :agent_id, :client_order_id, :request_dt, :dst_account, :amount, :currency, :contract

      def request_name; end

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
contract="#{contract}"/>#{extra_params}
</#{request_name}>
XML
      end

    protected

      def build_params(params = {})
          params.inject("") { |str, hash| str += "<#{hash.first}>#{hash[1]}</#{hash.first}>\n"}
      end
    end

    class TestDeposition < Deposition
      def request_name
        'testDepositionRequest'
      end
    end

    class MakeDeposition < Deposition
      def request_name
        'makeDepositionRequest'
      end

      def extra_params
        @extra_params
      end

      def set_extra_params(params={})
        @extra_params = "\n<paymentParams>\n#{build_params(params)}</paymentParams>"
      end
    end
  end
end
