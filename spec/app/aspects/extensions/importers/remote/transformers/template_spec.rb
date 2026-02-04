# frozen_string_literal: true

require "hanami_helper"

RSpec.describe Terminus::Aspects::Extensions::Importers::Remote::Transformers::Template do
  subject(:transformer) { described_class.new }

  describe "#call" do
    context "with URI indexes" do
      let :content do
        <<~CONTENT
          <p>{{IDX_0}}</p>
          <p>{{IDX_1}}</p>
          <p>{{IDX_2}}</p>
        CONTENT
      end

      let :proof do
        {
          template: <<~CONTENT
            <div class="screen screen--{{model.bit_depth}}bit screen--{{model.name}} screen--lg screen--{{model.orientation}} screen--1x">
              <div class="view view--full">
                <p>{{source_1}}</p>
            <p>{{source_2}}</p>
            <p>{{source_3}}</p>

              </div>
            </div>
          CONTENT
        }
      end

      it "answers success indexed sources" do
        expect(transformer.call({}, +content)).to be_success(proof)
      end
    end

    context "with field keys and values" do
      let :content do
        <<~CONTENT
          <p>{{ trmnl.plugin_settings.custom_fields_values.test }}</p>
          <p>{{ trmnl.plugin_settings.custom_fields[0].name }}</p>
        CONTENT
      end

      let :proof do
        {
          template: <<~CONTENT
            <div class="screen screen--{{model.bit_depth}}bit screen--{{model.name}} screen--lg screen--{{model.orientation}} screen--1x">
              <div class="view view--full">
                <p>{{ extension.values.test }}</p>
            <p>{{ extension.fields[0].name }}</p>

              </div>
            </div>
          CONTENT
        }
      end

      it "answers success indexed sources" do
        expect(transformer.call({}, +content)).to be_success(proof)
      end
    end
  end
end
