require "rails_helper"

RSpec.describe PostsController do
  let(:attributes) do
    {
      title: "The Danger of Stairs",
      content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed dapibus, nulla vel condimentum ornare, arcu lorem hendrerit purus, ac sagittis ipsum nisl nec erat. Morbi porta sollicitudin leo, eu cursus libero posuere ac. Sed ac ultricies ante. Donec nec nulla ipsum. Nunc eleifend, ligula ut volutpat.",
      category: "Non-Fiction"
    }
  end
  let(:found) { Post.find(@post.id) }

  before { @post = Post.create(attributes) }

  describe "showing a post" do
    it "shows a post" do
      get :show, params: { id: @post.id }
      expect(found).to eq(@post)
    end
  end

  describe "making valid updates" do
    let(:new_attributes) do
      attributes.merge(
        id: @post.id,
        title: "Fifteen Ways to Transcend Corporeal Form",
        category: "Fiction"
      )
    end

    it "updates successfully" do
      @post.update(new_attributes)
      expect(found.title).to eq(new_attributes[:title])
    end

    it "redirects to show page" do
      patch :update, params: new_attributes
      expect(response).to redirect_to(post_path(@post))
    end
  end

  describe "making invalid updates" do
    let(:bad_attributes) do
      attributes.merge(
        title: nil,
        content: "too short",
        category: "Speculative Fiction"
      )
    end

    before { @post.update(bad_attributes) }

    it "does not save" do
      expect(@post).to be_changed
    end

    it "does not update" do
      expect(found.title).to_not be_nil
    end

    it "has an error for missing title" do
      expect(@post.errors[:title]).to_not be_empty
    end

    it "has an error for too short content" do
      expect(@post.errors[:content]).to_not be_empty
    end

    it "has an error for invalid category" do
      expect(@post.errors[:category]).to_not be_empty
    end

    it "renders the form again" do
      patch :update, params: bad_attributes.merge(id: @post.id)
      expect(response).to render_template(:edit)
    end
  end
end
