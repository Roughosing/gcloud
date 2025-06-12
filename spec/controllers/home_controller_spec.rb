require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  render_views

  describe "GET #index" do
    before { get :index }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      expect(response).to render_template(:index)
    end

    describe "page content" do
      it "displays the main heading and description" do
        expect(response.body).to have_selector('h1.text-4xl', text: 'Welcome to GCloud Storage')
        expect(response.body).to have_selector('p.text-lg', text: /Store, organize, and access your files from anywhere/)
      end

      it "displays the sign in and sign up buttons" do
        expect(response.body).to have_selector('#sign-in-sign-up a.inline-block', text: 'Sign In')
        expect(response.body).to have_selector('#sign-in-sign-up a.inline-block', text: 'Sign Up')
      end

      it "displays the feature cards" do
        expect(response.body).to have_selector('div.p-6.bg-white#secure-storage') do |cards|
          expect(cards).to have_selector('h3', text: 'Secure Storage')
          expect(cards).to have_selector('p', text: 'Your files are encrypted and stored securely in the cloud.')
        end

        expect(response.body).to have_selector('div.p-6.bg-white#easy-organization') do |cards|
          expect(cards).to have_selector('h3', text: 'Easy Organization')
          expect(cards).to have_selector('p', text: 'Create folders and organize your files with drag-and-drop simplicity.')
        end

        expect(response.body).to have_selector('div.p-6.bg-white#access-anywhere') do |cards|
          expect(cards).to have_selector('h3', text: 'Access Anywhere')
          expect(cards).to have_selector('p', text: 'Access your files from any device, anywhere in the world.')
        end
      end
    end
  end
end
