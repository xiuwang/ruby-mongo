#!/usr/bin/env ruby
require 'mongo'

module MongoDB
  def self.connect_to_database_prod
    conn = Mongo::Connection.new(ENV['MONGODB_24_CENTOS7_SERVICE_HOST'], ENV['MONGODB_24_CENTOS7_SERVICE_PORT'])
    db = conn.db(ENV['MONGODB_DATABASE'])
    #db = conn.db('<database_name>')
    auth = db.authenticate(ENV['MONGODB_USER'], ENV['MONGODB_PASSWORD'])
    if auth == false
        conn.close
        return false
    end
  end
end
