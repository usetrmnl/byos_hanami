# frozen_string_literal: true

RSpec.shared_context "with screen mold" do
  let :mold do
    Terminus::Aspects::Screens::Mold[
      name: "test",
      label: "Test",
      content: "<p>Test</p>",
      mime_type: "image/png",
      bit_depth: 1,
      colors: 2,
      rotation: 0,
      offset_x: 0,
      offset_y: 0,
      width: 800,
      height: 480
    ]
  end
end
