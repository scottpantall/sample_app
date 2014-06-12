# Anything in full quotes is for the benefit of the user
# 'should' tests for things that should be there
# 'should_not' tests for things that should not be there
# Everything Rspec can be found here: http://rspec.info/
require 'spec_helper' #Loads spec_helper file

describe "Static pages" do  #All tests go in this loop

	subject { page }  #Defines 'page' as the subject of 'it'
  
  shared_examples_for "all static pages" do # shared_examples_for creates tests for all tests in loop
    it { should have_selector('h1', text: heading) }  # have_selector('<tag>, text: 'Text' or variable) tests for a tag with that text
    it { should have_title(full_title(page_title)) }  # have_title('title text' or variable) checks <title> tag with that text
  end

	describe "Home page" do
    before { visit root_path }  # 'before' ...um I'm not sure about the 'before' hook
    let(:heading)   { 'Sample App' }  # 'let(<:symbol>) { 'Text' }' creates a variable for this block
		let(:page_title) { '' }
    
    it_should_behave_like "all static pages"  # 'it_should_behave_like uses shared_examples_for tests
    it { should_not have_title('| Home') }
    it "should have the right links on the layout" do
      visit root_path
      click_link "About"
      expect(page).to have_title(full_title('About Us'))
      click_link "Help"
      expect(page).to have_title(full_title('Help'))
      click_link "Contact"
      expect(page).to have_title(full_title('Contact'))
      click_link "Home"
      click_link "Sign up now!"
      expect(page).to have_title(full_title(''))
      click_link "sample app"
      expect(page).to have_title(full_title(''))
    end

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem")
        FactoryGirl.create(:micropost, user: user, content: "Ipsum")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end
  
	describe "Help page" do
    before { visit help_path }
    let(:heading)   { 'Help' }
		let(:page_title) { 'Help' }
    
    it_should_behave_like "all static pages"
	end
  
  describe "About page" do
    before { visit about_path }
    let(:heading)   { 'About Us' }
		let(:page_title) { 'About Us' }
    
    it_should_behave_like "all static pages"
  end
  
  describe "Contact page" do
    before { visit contact_path }
    let(:heading)   { 'Contact' }
		let(:page_title) { 'Contact' }
    
    it_should_behave_like "all static pages"
  end
end