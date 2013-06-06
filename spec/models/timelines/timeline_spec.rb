  require File.expand_path('../../../spec_helper', __FILE__)

  describe Timelines::Timeline do
    describe 'helper methods for creation' do
      describe 'available_responsibles' do
        it 'is sorted according to general setting' do
          ab = FactoryGirl.create(:user, :firstname => 'a', :lastname => 'b')
        ba = FactoryGirl.create(:user, :firstname => 'b', :lastname => 'a')
        t  = Timelines::Timeline.new

        Setting.user_format = :firstname_lastname
        t.available_responsibles.should == [ab, ba]

        Setting.user_format = :lastname_firstname
        t.available_responsibles.should == [ba, ab]
      end
    end
  end
end
