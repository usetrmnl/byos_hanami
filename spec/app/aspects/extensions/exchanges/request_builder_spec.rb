# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Exchanges::RequestBuilder do
  subject(:builder) { described_class.new }

  describe "#call" do
    let :extension do
      Factory.structs[
        :extension,
        data: {
          "content_type" => "application/json",
          "sort" => "desc",
          "source_1" => "1",
          "source_2" => "2"
        }
      ]
    end

    it "answers single request without rendering" do
      exchange = Factory.structs[:extension_exchange]

      expect(builder.call(exchange, extension)).to contain_exactly(
        Terminus::Aspects::Extensions::Fetcher::Request[uri: exchange.template]
      )
    end

    it "answers single request when headers and body are nil" do
      exchange = Factory.structs[:extension_exchange, headers: nil, body: nil]

      expect(builder.call(exchange, extension)).to contain_exactly(
        Terminus::Aspects::Extensions::Fetcher::Request[uri: exchange.template]
      )
    end

    it "answers single request with nested body" do
      body = {
        array: [
          0,
          "one",
          {a: 1},
          {b: 2}
        ],
        hash: {
          one: {
            two: {
              three: 3
            }
          }
        },
        string: "test"
      }

      exchange = Factory.structs[:extension_exchange, body:]

      expect(builder.call(exchange, extension)).to contain_exactly(
        Terminus::Aspects::Extensions::Fetcher::Request[uri: exchange.template, body:]
      )
    end

    it "answers single request, fully rendered" do
      exchange = Factory.structs[
        :extension_exchange,
        headers: {"content_type" => "{{ extension.data.content_type }}"},
        verb: "post",
        template: "https://test.io/{{ extension.data.source_1 }}",
        body: {"sort" => "{{ extension.data.sort }}"}
      ]

      expect(builder.call(exchange, extension)).to contain_exactly(
        Terminus::Aspects::Extensions::Fetcher::Request[
          headers: {"content_type" => "application/json"},
          verb: "post",
          uri: "https://test.io/1",
          body: {"sort" => "desc"}
        ]
      )
    end

    it "answers mulitiple requests, fully rendered" do
      exchange = Factory.structs[
        :extension_exchange,
        headers: {"content_type" => "{{ extension.data.content_type }}"},
        verb: "post",
        template: "https://test.io/{{ extension.data.source_1 }}\n" \
                  "https://test.io/{{ extension.data.source_2 }}",
        body: {"sort" => "{{ extension.data.sort }}"}
      ]

      expect(builder.call(exchange, extension)).to eq(
        [
          Terminus::Aspects::Extensions::Fetcher::Request[
            headers: {"content_type" => "application/json"},
            verb: "post",
            uri: "https://test.io/1",
            body: {"sort" => "desc"}
          ],
          Terminus::Aspects::Extensions::Fetcher::Request[
            headers: {"content_type" => "application/json"},
            verb: "post",
            uri: "https://test.io/2",
            body: {"sort" => "desc"}
          ]
        ]
      )
    end
  end
end
