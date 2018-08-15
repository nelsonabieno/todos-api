class ItemsController < ApplicationController

  before_action :set_todo
  before_action :set_todo_item, only: [:show, :update, :delete]

  # GET /todos/:todo_id/items

  def index
    json_response (@todo.items )
  end

  # GET /todos/:todo_id/items/:id

  def show
    json_response(@todo_item)
  end

  # POST /todos/:todo_id/items

  def create
    @todo.items.create!(item_params)
    json_response(@todo, :created)
  end

  # PUT /todos/:todo_id/items/:id

  def update
    @todo_item.update(item_params)
    head :no_content
  end

  # DELETE /todos/:todo_id/items/:id

  def destroy
    @todo_item.destroy
    head :no_content
  end

  private

  def set_todo
    @todo = Todo.find(params[:todo_id])
  end

  def set_todo_item
    @todo_item = @todo.items.find(params[:id])
  end

  def item_params
    # params.require(:item).permit(:name,:done)
    params.permit(:name,:done)
  end
end

