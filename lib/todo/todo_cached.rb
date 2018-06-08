# TodoCached class
# This is an cached layer used over Todo model object
class TodoCached
  class << self
    def new(*args)
      Todo.new(*args)
    end

    def all(*args)
      Rails.cache.fetch('todos/all') { Todo.all(*args) }
    end

    def find(*args)
      Rails.cache.fetch("todos/#{args.first}") { Todo.find(*args) }
    end

    def clear_cached_todos
      Rails.cache.delete_matched('todos/*')
    end
  end
end
