$redis = Redis::Namespace.new('todo_list', redis: Redis.new)
