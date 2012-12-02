require 'spec_helper'

describe 'Projects' do
  let(:user) { create :user, email_frequency: 'daily' }
  subject { page }

  describe 'suggesting a new project' do
    before do
      login user
      visit dashboard_path
    end

    it 'allows the user to suggest a project to contribute to' do
      click_link 'Suggest a project'
      fill_in 'Name', with: Faker::Lorem.words.first
      fill_in 'Github url', with: Faker::Internet.url
      fill_in 'Summary', with: Faker::Lorem.paragraphs.first
      fill_in 'Main language', with: 'Ruby'
      click_on 'Submit Project'
    end

    it 'consolidates duplicate projects into one with all descriptions' do
      first_project  = create :project, description: "first sample description"
      second_project = create :project, description: "second sample description"

      # Skip validations to create data that was created before the
      # unique github_url validation was added
      second_project.update_attribute(:github_url, first_project.github_url)

      visit projects_path

      should have_content first_project.description
      should have_content second_project.description

      project_links = all(:xpath, "//a[@href = '#{first_project.github_url}']")
      project_links.count.should == 1

    end
  end
end
