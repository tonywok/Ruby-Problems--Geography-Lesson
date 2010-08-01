require 'spec'
require 'spec_helper'
require 'geo'

describe Geo do 
  
  let(:geo) { Geo.new }

  describe "When converting signed decimal degrees" do
    it "should just flip the lat/long coords" do
      geo.get_xy("45.1234 36.2345").should == [36.2345, 45.1234]
    end

    it "should remove the positive signs too" do
      geo.get_xy("+45.1234 +36.2345").should == [36.2345, 45.1234]
    end

    it "should however, keep the negative signs" do
      geo.get_xy("-45.1234 -36.2345").should == [-36.2345, -45.1234]
    end

    it "should do 'bothers' too" do
      geo.get_xy("-45.1234 36.2345").should == [36.2345, -45.1234]
    end

  end

  describe "when converting decimal degrees with directions" do
    
    it "should treat N and E as positive" do
      geo.get_xy("45.1234 N 36.2345 E").should == [36.2345, 45.1234]
    end

    it "should treat S and W as negative" do
      geo.get_xy("45.1234 S 36.2345 W").should == [-36.2345, -45.1234]
    end

    it "should be able to mix and match N with W" do
      geo.get_xy("45.1234 N 36.2345 W").should == [-36.2345, 45.1234]
    end

    it "should be able to mix and match S and E" do
      geo.get_xy("45.1234 S 36.2345 E").should == [36.2345, -45.1234]
    end

  end

  describe "when converting to decimal degrees and minutes" do

    it "should take into account up to minute accuracy" do
      geo.get_xy("40 30.6 N 65 36.36 E").should == [65.606, 40.51]
    end

    it "should not forget about those pesky negatives" do
      geo.get_xy("40 30.6 S 65 36.36 W").should == [-65.606, -40.51]
    end

    it "should be able to have two negatives with minute accuracy" do
      geo.get_xy("-40 30.6 -65 36.36").should == [-65.606, -40.51]
    end

    it "should be able to mix and match pos and neg with accuracy" do
      geo.get_xy("N 40 30.6 W 65 36.36").should == [-65.606, 40.51]
    end

  end

  describe "when Decimal Degrees, Minutes, and Seconds" do
    
    it "should take into account up to second accuracy" do
      geo.get_xy("45 45 4.5 N 38 30 10.8 E").should == [38.503,45.75125]
    end

    it "should not forget about direction when considering minutes and seconds" do
      geo.get_xy("45 45 4.5 N 38 30 10.8 W").should == [-38.503,45.75125]
    end

    it "should handle positive considering minutes and seconds" do
      geo.get_xy("45 45 4.5 38 30 10.8").should == [38.503,45.75125]
    end

    it "should handle hard coded negative with minute/second accuracy" do
      geo.get_xy("-45 45 4.5 38 30 10.8").should == [38.503,-45.75125]
    end
  end
end
