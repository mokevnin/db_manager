require 'optparse'

module DbManager
  class CLI
    module Options
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Return a new CLI instance with the given arguments pre-parsed and
        # ready for execution.
        def parse(args)
          cli = new(args)
          cli.parse_options!
          cli
        end
      end

      # The hash of (parsed) command-line options
      attr_reader :options

      # Return an OptionParser instance that defines the acceptable command
      # line switches for Capistrano, and what their corresponding behaviors
      # are.
      def option_parser #:nodoc:
        #@logger = Logger.new

        @option_parser ||= OptionParser.new do |opts|
          opts.banner = "Usage: #{File.basename($0)} [options] action ..."

          opts.on("-h", "--help", "Display this help message.") do
            puts opts
            exit
          end
          opts.on("-d", "--dir DIRNAME", "Config directory (default: current)"
          ) { |value| @options[:dir] = value }
          opts.on("-a", "--adapter ADAPTER", "DB adapter"
          ) { |value| @options['adapter'] = value }
        end

        @option_parser 
      end

      # If the arguments to the command are empty, this will print the
      # allowed options and exit. Otherwise, it will parse the command
      # line and set up any default options.
      def parse_options! #:nodoc:
        if args.empty?
          warn "Please specify at least one action to execute."
          warn option_parser
          exit
        end

        extract_environment_variables!

        @options = { :recipes => [], :actions => [],
          :vars => {}, :pre_vars => {} }
        @options[:dir] ||= Dir.pwd 

        option_parser.parse!(args)
        mandatory = ['adapter']
        missing = mandatory.select{ |param| options[param].nil? }
        if not missing.empty?
          puts "Missing options: #{missing.join(', ')}"
          puts option_parser                               
          exit                                       
        end   

        @options[:actions].concat(args)
      end

      # Extracts name=value pairs from the remaining command-line arguments
      # and assigns them as environment variables.
      def extract_environment_variables! #:nodoc:
        args.delete_if do |arg|
          next unless arg.match(/^(\w+)=(.*)$/)
          ENV[$1] = $2
        end
      end

      # Looks for a default recipe file in the current directory.
      #def look_for_default_recipe_file! #:nodoc:
        #current = Dir.pwd

        #loop do
          #%w(Capfile capfile).each do |file|
            #if File.file?(file)
              #options[:recipes] << file
              #@logger.info "Using recipes from #{File.join(current,file)}"
              #return
            #end
          #end

          #pwd = Dir.pwd
          #Dir.chdir("..")
          #break if pwd == Dir.pwd # if changing the directory made no difference, then we're at the top
        #end

        #Dir.chdir(current)
      #end
    end
  end
end
