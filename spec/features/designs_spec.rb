# frozen_string_literal: true

require "hanami_helper"

RSpec.describe "Designs", :db do
  let(:model) { Factory[:model] }
  let(:template) { Factory[:screen_template] }

  before { template }

  it "views index" do
    visit routes.path(:designs)
    expect(page).to have_text(template.label)
  end

  it "creates", :js do
    model
    visit routes.path(:designs)
    click_link "New"
    select model.label, from: "model_id"
    fill_in "template[label]", with: "Test"
    fill_in "template[name]", with: "test"
    click_button "Save"

    expect(page).to have_text("Edit Design")
  end

  it "edits", :js do
    visit routes.path(:design_edit, id: template.id)
    expect(page).to have_text("Edit Design")
  end

  it "exports" do
    visit routes.path(:designs)
    click_link "Download"

    expect(page.source.encoding).to eq(Encoding::ASCII_8BIT)
  end

  it "deletes", :js do
    visit routes.path(:designs)
    accept_prompt { click_button "Delete" }

    expect(page).to have_no_text(template.label)
  end
end
