require 'spec_helper'
module Alf
  module Sequel
    describe Relvar, 'update' do

      let(:base){
        create_names_schema(sequel_names_adapter)
      }
      let(:virtual){
        base.where(:name => "Jones")
      }

      subject {
        virtual.update(:name => "JONES")
      }

      before do
        virtual.to_a.should_not be_empty
      end

      it 'returns the relvar itself' do
        subject.should eq(virtual)
      end

      it 'updates the tuples' do
        subject
        resulting = base.project([:name]).value
        expected  = supplier_names_relation.
                      minus(Relation(:name => "Jones")).
                      union(Relation(:name => "JONES"))
        resulting.should eq(expected)
      end

    end
  end
end