# Create a stub Statsd client.
# Replace later with a proper client
METRICS = (Class.new do
  def increment(*args); end
  def timing(*args); end
end).new

SELECT_DELETE = / FROM `(w+)`/
INSERT = /^INSERT INTO `(w+)`/
UPDATE = /^UPDATE `(w+)`/

ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, start, finish, id, payload|

  # Payload example:
  # {
  #   controller: "PostsController",
  #   action: "index",
  #   params: {"action" => "index", "controller" => "posts"},
  #   format: :html,
  #   method: "GET",
  #   path: "/posts",
  #   status: 200,
  #   view_runtime: 46.848,
  #   db_runtime: 0.157
  # }

  METRICS.increment "controller.status.#{payload[:status]}"
  METRICS.increment "controller.path.#{payload[:path]}"
  METRICS.increment "controller.method.#{payload[:method].downcase}"
  METRICS.increment "controller.#{payload[:controller].downcase}.#{payload[:action].downcase}"

  METRICS.timing 'controller.view.total_render_time', payload[:view_runtime], 1
  METRICS.timing 'controller.db.total_query_time', payload[:db_runtime], 1

end

ActiveSupport::Notifications.subscribe "sql.active_record" do |name, start, finish, id, payload|

  # Payload example:
  # {
  #   :sql=>"SELECT  \"users\".* FROM \"users\" WHERE \"users\".\"email\" = $1  ORDER BY \"users\".\"id\" ASC LIMIT 1",
  #   :name=>"User Load",
  #   :connection_id=>70192736276280,
  #   :statement_name=>"a1",
  #   :binds=>
  #    [[#<ActiveRecord::ConnectionAdapters::PostgreSQLColumn:0x007fae1192ab78
  #    @array=false,
  #    @cast_type=#<ActiveRecord::Type::String:0x007fae11c32258 @limit=nil, @precision=nil, @scale=nil>,
  #    @default="",
  #    @default_function=nil,
  #    @name="email",
  #    @null=false,
  #    @sql_type="character varying">,
  #    "cso1@example.com"]]
  # }

  case payload[:sql]
    when /^SELECT/
      payload[:sql] =~ SELECT_DELETE
      METRICS.increment('sql.select')
      METRICS.timing("sql.#{$1}.select.query_time", (finish - start) * 1000, 1)
    when /^DELETE/
      payload[:sql] =~ SELECT_DELETE
      METRICS.increment('sql.delete')
      METRICS.timing("sql.#{$1}.delete.query_time", (finish - start) * 1000, 1)
    when /^INSERT/
      payload[:sql] =~ INSERT
      METRICS.increment('sql.insert')
      METRICS.timing("sql.#{$1}.insert.query_time", (finish - start) * 1000, 1)
    when /^UPDATE/
      payload[:sql] =~ UPDATE
      METRICS.increment('sql.update')
      METRICS.timing("sql.#{$1}.update.query_time", (finish - start) * 1000, 1)
  end
end