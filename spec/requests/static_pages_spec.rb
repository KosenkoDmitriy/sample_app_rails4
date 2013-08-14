require 'spec_helper'
#describe "StaticPages" do
#  describe "GET /static_pages" do
#    it "works! (now write some real specs)" do
#      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#      get static_pages_index_path
#      response.status.should be(200)
#    end
#  end
#end


describe "Static pages" do
  
  let(:base_title) { "Base Title of the Sample App on Ruby on Rails 4" }
  subject { page }
  
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }  
  end
  
  it "should have the right links on the layout" do 
    visit root_path
    click_link about_path
    to have_title(full_title("About Us"))
  end
  
  describe "Home page" do
    before { visit root_path }
    let(:heading)   { 'Sample App' }
    let(:page_title)   { '' }
    
    it_should_behave_like "all static pages"
    it { should have_content('Sample App') }
    it { should have_title("| Home") }
  end
  
  
  describe "Help page" do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
#    it { should have_title(full_title("#{base_title} | Help")) }
  end
  
  describe "About page" do
    before { visit about_path }
    it { should have_content('About') }
    it { should have_title('About Us') }

  end
  
  describe "Contact page" do
    before { visit contact_path }
    
    it { should have_selector('h1', text: 'Contact')}
    it { should have_content('Contact') }
    it { should have_title('Contact')}
  end
  
end