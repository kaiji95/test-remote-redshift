require 'securerandom'
require 'uri'

module Test
  module Remote
    module Redshift
      class Database
        attr_reader :host, :port, :user, :password, :database_prefix
        attr_reader :psql_uri, :redshift_uri, :database_name

        def initialize(uri:, database_prefix:)
          raise 'database prefix should not be empty' if database_prefix.nil? || database_prefix.empty?
          u = URI(uri)
          @host = u.host
          @port = u.port
          @user = URI.unescape(u.user)
          @password = URI.unescape(u.password)
          @database_prefix = database_prefix
          @database_name = generate_database_name

          @psql_uri = "postgres://#{u.user}:#{u.password}@#{host}:#{port}/#{database_name}"
          @redshift_uri = "redshift://#{u.user}:#{u.password}@#{host}:#{port}/#{database_name}"
        end

        def generate_database
          `PGPASSWORD="#{password}" createdb -h #{host} -p #{port} -U #{user} #{database_name}`
          self
        end

        def generate_database_with_schema_sql_file(schema_sql_file)
          `PGPASSWORD="#{password}" createdb -h #{host} -p #{port} -U #{user} #{database_name}`
          `psql #{psql_uri} -f #{schema_sql_file}`
          self
        end

        def drop_database(db_name)
          `PGPASSWORD="#{password}" dropdb -h #{host} -p #{port} -U #{user} #{db_name}`
        end
        
        def drop_current_database
          # off databse link
          `psql #{psql_uri} -c "SELECT pg_terminate_backend(procpid) FROM pg_stat_activity WHERE datname = '#{database_name}';"`
          drop_database(database_name)
        end

        def clean_old_database(days_ago: 1)
          time_before = Time.now.to_i - days_ago * 60 * 60 * 24
          dbs = `psql #{psql_uri} -c "SELECT datname FROM pg_database WHERE datname ~ '#{database_prefix}_[0-9]+_[a-z0-9]+$';"`
          (dbs.split("\n")[2..-2] || []).each do |db|
            db_time = db.strip!.split("_")[-2].to_i
            if db_time > 0 && db_time < time_before
              drop_database(db) 
            end
          end
          self
        end

        private

        def generate_database_name
          timestamp = Time.now.to_i
          "#{database_prefix}_#{timestamp}_#{SecureRandom.hex(4)}"
        end
      end
    end
  end
end
