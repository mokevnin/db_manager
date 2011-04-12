require 'db_manager/cli/execute'
require 'db_manager/cli/options'
require 'db_manager'

module DbManager
  class CLI
    # The array of (unparsed) command-line options
    attr_reader :args

    def initialize(args)
      @args = args.dup
    end

    # Mix-in the actual behavior
    include Execute, Options
  end
end

