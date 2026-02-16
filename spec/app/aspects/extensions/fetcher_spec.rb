# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Fetcher do
  subject(:fetcher) { described_class.new http: }

  describe "#call" do
    let(:uri) { "https://ghibliapi.vercel.app/films" }
    let(:extension) { Factory.structs[:extension, uris: [uri]] }

    describe ".mime_type_for" do
      let :response do
        HTTP::Response.new headers: {"Content-Type" => "text/plain"},
                           verb: :get,
                           uri: "http://test.io",
                           body: "{}",
                           status: 200,
                           version: 1.0
      end

      it "answer MIME type for header" do
        headers = {"Accept" => "application/json"}
        expect(described_class.mime_type_and_body_for(headers, response)).to eq(
          ["application/json", "{}"]
        )
      end

      it "answer MIME type for response without headers" do
        expect(described_class.mime_type_and_body_for(nil, response)).to eq(["text/plain", "{}"])
      end

      it "answer MIME type for response with empty headers" do
        expect(described_class.mime_type_and_body_for({}, response)).to eq(["text/plain", "{}"])
      end
    end

    context "with specific content type header" do
      let :extension do
        Factory.structs[:extension, headers: {"Accept" => "application/json"}, uris: [uri]]
      end

      let :http do
        HTTP::Fake::Client.new do
          get "/films" do
            headers["Content-Type"] = "text/plain"
            status 200

            <<~BODY
              [
                {
                  "title": "Castle in the Sky",
                  "director": "Hayao Miyazaki"
                }
              ]
            BODY
          end
        end
      end

      it "answers success due to header overriding response content type" do
        expect(fetcher.call(uri, extension)).to be_success(
          "source" => Success(
            [
              {
                "title" => "Castle in the Sky",
                "director" => "Hayao Miyazaki"
              }
            ]
          )
        )
      end
    end

    context "with JSON" do
      let :http do
        HTTP::Fake::Client.new do
          get "/films" do
            headers["Content-Type"] = "application/json"
            status 200

            <<~BODY
              [
                {
                  "title": "Castle in the Sky",
                  "director": "Hayao Miyazaki"
                }
              ]
            BODY
          end
        end
      end

      it "answers success" do
        expect(fetcher.call(uri, extension)).to be_success(
          "source" => Success(
            [
              {
                "title" => "Castle in the Sky",
                "director" => "Hayao Miyazaki"
              }
            ]
          )
        )
      end
    end

    context "with image" do
      let :http do
        HTTP::Fake::Client.new do
          get "/films" do
            headers["Content-Type"] = "image/png"
            status 200

            "<binary>"
          end
        end
      end

      it "answers success" do
        expect(fetcher.call(uri, extension)).to be_success("source" => Success("<binary>"))
      end
    end

    context "with CSV" do
      let :http do
        HTTP::Fake::Client.new do
          get "/films" do
            headers["Content-Type"] = "text/csv"
            status 200

            <<~BODY
              title,director
              Castle in the Sky,Hayao Miyazaki
            BODY
          end
        end
      end

      it "answers success" do
        expect(fetcher.call(uri, extension)).to be_success(
          "source" => Success(
            [
              {
                "title" => "Castle in the Sky",
                "director" => "Hayao Miyazaki"
              }
            ]
          )
        )
      end
    end

    context "with text" do
      let :http do
        HTTP::Fake::Client.new do
          get "/films" do
            headers["Content-Type"] = "text/plain"
            status 200

            <<~BODY
              one
              two
              three
            BODY
          end
        end
      end

      it "answers success" do
        expect(fetcher.call(uri, extension)).to be_success("source" => Success(%w[one two three]))
      end
    end

    context "with XML (text)" do
      let :http do
        HTTP::Fake::Client.new do
          get "/films" do
            headers["Content-Type"] = "text/xml"
            status 200

            <<~BODY
              <?xml version="1.0" encoding="UTF-8"?>
              <catalog>Empty</catalog>
            BODY
          end
        end
      end

      it "answers success" do
        expect(fetcher.call(uri, extension)).to be_success(
          "source" => Success("catalog" => "Empty")
        )
      end
    end

    context "with XML (application)" do
      let :http do
        HTTP::Fake::Client.new do
          get "/films" do
            headers["Content-Type"] = "application/xml"
            status 200

            <<~BODY
              <?xml version="1.0" encoding="UTF-8"?>
              <catalog>Empty</catalog>
            BODY
          end
        end
      end

      it "answers success" do
        expect(fetcher.call(uri, extension)).to be_success(
          "source" => Success("catalog" => "Empty")
        )
      end
    end

    context "with XML (RSS)" do
      let :http do
        HTTP::Fake::Client.new do
          get "/films" do
            headers["Content-Type"] = "application/rss+xml"
            status 200

            <<~BODY
              <?xml version="1.0" encoding="UTF-8"?>
              <catalog>Empty</catalog>
            BODY
          end
        end
      end

      it "answers success" do
        expect(fetcher.call(uri, extension)).to be_success(
          "source" => Success("catalog" => "Empty")
        )
      end
    end

    context "with XML (Atom)" do
      let :http do
        HTTP::Fake::Client.new do
          get "/films" do
            headers["Content-Type"] = "application/atom+xml"
            status 200

            <<~BODY
              <?xml version="1.0" encoding="UTF-8"?>
              <catalog>Empty</catalog>
            BODY
          end
        end
      end

      it "answers success" do
        expect(fetcher.call(uri, extension)).to be_success(
          "source" => Success("catalog" => "Empty")
        )
      end
    end

    context "with unknown MIME type" do
      let :http do
        HTTP::Fake::Client.new do
          get "/films" do
            headers["Content-Type"] = "text/html"
            status 200

            <<~HTML
              <p>A test.</p>
            HTML
          end
        end
      end

      it "answers errors" do
        expect(fetcher.call(uri, extension)).to be_failure("Unknown MIME Type: text/html.")
      end
    end

    context "with bad HTTP status" do
      let :http do
        HTTP::Fake::Client.new do
          get "/films" do
            headers["Content-Type"] = "application/json"
            status 404

            <<~BODY
              {"error": "Danger!"}
            BODY
          end
        end
      end

      it "answers errors" do
        expect(fetcher.call(uri, extension)).to match(Failure(kind_of(HTTP::Response)))
      end
    end
  end
end
