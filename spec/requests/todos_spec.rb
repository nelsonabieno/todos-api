require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  # initialize test data
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  # Test suite for GET /todos
  describe 'GET /todos' do
    # make HTTP get request before each example
    before { get '/todos'}

    it 'returns todos' do
      # Using `json` custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /todos/:id
  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}" }

    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end
    # Test suite for POST /todos
    describe 'POST /todos' do
      # valid payload
      let(:valid_attributes) { {title: 'Movies in the space', created_by: 'Nelson' } }

    context 'when the request is valid' do
      before { post '/todos', params: valid_attributes }

      it 'creates a todo' do
        expect(json['title']).to eq("Movies in the space")
        expect(json['created_by']).to eq('Nelson')
      end

      it 'returns status code 201 ' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/todos', params: { title: 'Malagna' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Created by can't be blank/)
      end
    end
  end

  # Test suite for PUT /todos/:id
  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title:'Parachutes in the space ', created_by: 'Johnson' } }

    context "when a todo has been updated" do
      before { put '/todos/#{todo_id}', params:valid_attributes  }

      it 'should return a status code of 204' do
        expect(response).to have_http_status(204)
      end

      it 'should return an empty response' do
        expect(response.body).to be_empty
      end

      it 'should have the updated todo title' do
        expect(json['title']).to match(/Parachutes in the space /)
      end

    end
  end

  describe 'DELETE /todos/:id' do
    before { delete '/todos/#{todo_id}' }

    context 'when a todo has been deleted' do
      it 'should return a status code of 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

end