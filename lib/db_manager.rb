require 'yaml'

module DbManager
  def self.execute(action, options)
    @directory = options[:dir]
    configurations = load_database_configurations(@directory)
    @db_options = configurations[options['adapter']]
    @db_name = @db_options.delete('database')
    unless @db_options
      raise "'#{options['adapter']}' does not exists. Select from: #{@db_options.keys.join(', ')}"
    end

    send action
  end

  def self.create
    connection(@db_options) do |con|
      con.create_database @db_name
    end

    puts "'#{@db_name}' was create"
  end

  def self.drop
    
    case @db_options['adapter']
    when /mysql/
    connection(@db_options) do |con|
      con.drop_database @db_name
    end
    #when /^sqlite/
      #require 'pathname'
      #path = Pathname.new(database)
      ##file = path.absolute? ? path.to_s : File.join(Rails.root, path)

      #FileUtils.rm(file)
    #when 'postgresql'
      #ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
      #ActiveRecord::Base.connection.drop_database database
    end

    puts "'#{@db_name}' was deleted"
  end

  def self.schema_load
    connection(@db_options.merge!(:database => @db_name)) do |con|
      #ActiveRecord::Migration.verbose = false
      load(@directory + '/schema.rb')
    end

    puts "schema was loaded"
  end

  def self.reset
    drop
    create
    schema_load
  end
end

def connection(options, &block)
  ActiveRecord::Base.establish_connection options
  yield ActiveRecord::Base.connection
  ActiveRecord::Base.clear_active_connections!
end

def load_database_configurations(dir)
  opts = YAML::load(File.read(dir + '/database.yml'))
  opts.each_pair { |adapter, options| options['adapter'] = adapter }
  ActiveRecord::Base.configurations = opts
end
