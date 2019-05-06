require 'spec_helper'
module Alf
  module Sequel
    describe Adapter, "recognizes?" do

      it "recognizes ::Sequel::Database objects" do
        begin
          db = ::Sequel.connect(sequel_database_memory)
          Adapter.recognizes?(db).should be_truthy
        ensure
          db.disconnect if db
        end
      end

      it "recognizes sqlite files" do
        Adapter.recognizes?("#{sequel_database_path}").should be_truthy
      end

      it "recognizes in memory sqlite databases" do
        Adapter.recognizes?(sequel_database_memory).should be_truthy
      end

      it "recognizes a Path to a sqlite databases" do
        Adapter.recognizes?(sequel_database_path).should be_truthy
        Adapter.recognizes?("nosuchone.db").should be_truthy
      end

      it "recognizes database uris" do
        Adapter.recognizes?("postgres://localhost/database").should be_truthy
        Adapter.recognizes?(sequel_database_uri).should be_truthy
      end

      it "recognizes a Hash ala Rails" do
        config = {"adapter" => "sqlite", "database" => "#{sequel_database_path}"}
        Adapter.recognizes?(config).should be_truthy
        Adapter.recognizes?(Tools.symbolize_keys(config)).should be_truthy
      end

      it "should not be too permissive" do
        Adapter.recognizes?(nil).should be_falsey
      end

      it "should let Adapter autodetect sqlite files" do
        Alf::Adapter.autodetect(sequel_database_path).should be(Adapter)
        Alf::Adapter.autodetect("#{sequel_database_path}").should be(Adapter)
      end

    end
  end
end
