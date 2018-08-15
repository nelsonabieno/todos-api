require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  # Initialize the test data
  let!(:todo) { create(:todo) }
  let(:todo_id) { todo.id }
  let!(:items) { create_list(:item, 10, todo_id: todo_id) }
  let(:id) { items.first.id }

  # Test suite for GET /todos/:todo_id/items
  describe "GET /todos/:todo_id/items" do
    before { get "/todos/#{todo_id}/items" }

    context "when todo exist" do
      # before { get params:{ :todo_id => todo_id, :name=> "light shiners", :done=> true  } }
      it "should return a status 200" do
        puts "========"
        puts todo_id
        puts json(response.body).size
        expect(response).to have_http_status(200)
      end

      it "returns all todo items" do
        expect(json.size).to eq(10)
      end
    end

    context "when a todo does not exist" do
      let(:todo_id) {0}
      it "returns code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Coudln't find Todo/)
      end
    end

  end

  # Test suite for POST /todos/:todo_id/items
  describe "POST /todos/:todo_id/items" do
    let(:valid_attributes)  { { :name => "Bleasers", :done => true } }

    context "when posting a todo" do
      before { post "/todos/#{todo_id}/items", params: valid_attributes  }
      it { expect(response).to have_http_status(201)}
      it { expect(json['name']).to match(/Bleasers/) }
      it { expect(json['done']).to eq(true)}
    end

    context "when an invalid request is posted" do
      before { post "/todos/#{todo_id}/items", params: { :name => "Bleasers", :done => 3 }  }
      it "should return  400 status " do
        expect(response).to have_http_status(400)
      end
    end

    context "when an empty request is sent" do
      before { post "/todos/#{todo_id}/items", params: {} }
      it "returns status code 422" do
        expect(response).to have_http_status(422)
      end

      it "returns a failure message" do
        expect(response.body).to match(/Validation failed: Name can't be blank/)
      end
    end
  end

  # Test suite for PUT /todos/:todo_id/items
  describe "PUT /todos/:todo_id/items/:id" do
    let(:valid_attributes)  { {:name => "Jack"} }
    before{ put "/todos/#{todo_id}/items/#{id}", params: valid_attributes }

    context "when updating an item that exists" do
      it { expect(response.status).to have_http_status(204)}
      it { expect(response.body).to be_empty}
      updated_item = Item.find(id)
      it "updates the item" do
        expect(updated_item.name).to match(/Jack/)
      end
    end

    context "when updating an item that doesnot exist" do
      let(:id) {0}

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end

  end


  # Test suite for DELETE /todos/:id
  describe "DELETE /todos/:todo_id/items/:id" do
    before { delete "/todos/#{todo_id}/#{id}" }

    context "when deleting a todo todo" do
      it { expect(response.status).to have_http_status(204) }
      it { expect(response.body).to be_empty}
    end
  end
end
