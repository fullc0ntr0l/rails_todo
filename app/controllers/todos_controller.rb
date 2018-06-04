class TodosController < ApplicationController
  # GET /todos
  # GET /todos.json
  def index
    # @todos = Todo.all
    @todos = fetch_cached_todos

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @todos }
    end
  end

  # GET /todos/new
  # GET /todos/new.json
  def new
    @todo = Todo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @todo }
    end
  end

  # GET /todos/1/edit
  def edit
    @todo = Todo.find(params[:id])
  end

  def show
    @todo = Todo.find(params[:id])
  end

  # POST /todos
  # POST /todos.json
  def create
    @todo = Todo.new(params[:todo])

    respond_to do |format|
      if @todo.save
        format.html { redirect_to @todo, notice: 'Todo was successfully created.' }
        format.json { render json: @todo, status: :created, location: @todo }
      else
        format.html { render action: "new" }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /todos/1
  # PUT /todos/1.json
  def update
    @todo = Todo.find(params[:id])

    respond_to do |format|
      if @todo.update_attributes(params[:todo])
        format.html { redirect_to @todo, notice: 'Todo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.json
  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy

    respond_to do |format|
      format.html { redirect_to todos_url }
      format.json { head :no_content }
    end
  end

  private

  def fetch_cached_todos
    todos = $redis.get('todos')

    if todos.nil?
      todos = Todo.all.to_json
      $redis.set('todos', todos)
      $redis.expire('todos', 1.hour.to_i)
    end

    JSON.parse(todos)
  end
end
