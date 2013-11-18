require 'spec_helper'

describe Relationship do #1
     before(:each)do
     @follower =Factory(:user)
     @followed =Factory(:user,:email=>Factory.next(:email))
     @attr={:followed_id =>@followed.id}
    end

    it"should create a instance with valid attributes"do
     @follower.relationships.create!(@attr)
    end

#-----------------------------------
  describe"follow method"do

   before(:each)do
   @relationship =@follower.relationships.create!(@attr)
   end

   it"should have a follower attribut"do
    @relationship.should respond_to(:follower)
   end
 

    it"should have a right follower"do
     @relationship.follower.should ==@follower
   
   end

 it"should have a followed attribut"do
    @relationship.should respond_to(:followed)
   end
 

    it"should have a right followed user"do
     @relationship.followed.should ==@followed
   
   end
end
#---------------
describe"validations"do
it "should require a follower id"do
  Relationship.new(@attr).should_not be_valid
 end
it"should require a folowed id"do
@follower.relationships.build.should_not be_valid
end





end
#-----------------------------------
end #1

















