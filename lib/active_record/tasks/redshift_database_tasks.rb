# frozen_string_literal: true

module ActiveRecord
  module Tasks # :nodoc:
    class RedshiftDatabaseTasks # :nodoc:
      def initialize(db_config)
      end

      def create
      end

      def drop
      end

      def purge
      end

      def structure_dump(filename, extra_flags)
      end

      def structure_load(filename, extra_flags)
      end
    end
  end
end
