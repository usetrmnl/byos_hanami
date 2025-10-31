# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Fetcher do
  subject(:fetcher) { described_class.new http: }

  describe "#call" do
    let(:uri) { "https://ghibliapi.vercel.app/films" }
    let(:extension) { Factory.structs[:extension, uris: [uri]] }

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
          "data" => [
            {
              "title" => "Castle in the Sky",
              "director" => "Hayao Miyazaki"
            }
          ]
        )
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
          "data" => [
            {
              "title" => "Castle in the Sky",
              "director" => "Hayao Miyazaki"
            }
          ]
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
        expect(fetcher.call(uri, extension)).to be_success("data" => %w[one two three])
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
        expect(fetcher.call(uri, extension)).to be_success("catalog" => "Empty")
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
        expect(fetcher.call(uri, extension)).to be_success("catalog" => "Empty")
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
        expect(fetcher.call(uri, extension)).to be_success("catalog" => "Empty")
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
        expect(fetcher.call(uri, extension)).to be_success("catalog" => "Empty")
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
  end
end
