module DbManager
  class CLI
    module Execute
      def self.included(base) #:nodoc:
        base.extend(ClassMethods)
      end

      module ClassMethods
        # Invoke db_manager using the ARGV array as the option parameters.
        def execute
          parse(ARGV).execute!
        end
      end

      def execute!
        Array(options[:actions]).each do |action|
          DbManager.execute action, options
        end
      end
    end
  end
end
