require 'spec_helper'
require 'pry'
require 'ostruct'

# Mock this
module VagrantCloner
  class BaseCloner
    def datestring; "2013-01-01"; end
  end
end

require 'vagrant-cloner/cloners/mysql'

module VagrantCloner
  module Cloners
    describe MysqlCloner do
      describe "#extract_relevant_options" do
        describe "when missing keys" do
          before do
            subject.stub(:options).and_return(OpenStruct.new({:remote_db_password => ''}))
            subject.extract_relevant_options
          end

          its(:remote_db_password) { should be_empty }
        end
      end

      describe "#mysql_password_flag" do
        it "produces nothing if password is nil or empty" do
          result = subject.mysql_password_flag("")
          result.should be_empty
        end

        it "outputs the flag if password is present" do
          result = subject.mysql_password_flag("test")
          result.should == %Q{ -p"test"}
        end
      end
    end
  end
end
