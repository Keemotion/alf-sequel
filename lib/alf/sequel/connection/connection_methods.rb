module Alf
  module Sequel
    class Connection
      module ConnectionMethods

        def connection_uri(with_password = false)
          if conn_spec.is_a?(Hash)
            cs = Tuple(self.conn_spec)
            adapter, host, port, database, user, password = cs.values_at(:adapter, :host, :port, :database, :user, :password)
            user = "#{user}:#{password}" if user and password and with_password
            user = "#{user}@"            if user
            host = "localhost"           if host.nil? and not(adapter =~ /sqlite/)
            host = "#{host}:#{port}"     if host and port
            host = "/#{user}#{host}"     if host or user
            "#{adapter}:/#{host}/#{database}"
          elsif conn_spec.is_a?(String)
            conn_spec
          else
            "Alf::Sequel::Connection(#{conn_spec})"
          end
        end

        def ping
          sequel_db.test_connection
        end

        def close
          @sequel_db.disconnect if @sequel_db && @sequel_db != conn_spec
        end

        def close!
          @sequel_db.disconnect if @sequel_db
        end

        def with_sequel_db
          yield(sequel_db)
        end

        # Yields a Sequel::Database object
        def sequel_db
          @sequel_db ||= Adapter.sequel_db(conn_spec)
          block_given? ? yield(@sequel_db) : @sequel_db
        end

      end # module ConnectionMethods
    end # module Connection
  end # module Sequel
end # module Alf
