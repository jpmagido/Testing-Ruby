require 'test_helper'
require 'date'

class EventTest < ActiveSupport::TestCase

	test "try one before" do	
		Event.create(kind: "opening")
		assert_equal "opening", Event.last.kind
	end

	test "Is my availability list the length I asked ?" do
        assert_equal 10, availabilities(10).length
        assert_equal 7, availabilities(7).length
        assert_equal 4, availabilities(4).length
        assert_equal 2, availabilities(2).length      
    end

    test "When I ask availibility for 5 days, is my answer an array ?" do
    	assert_equal Array, availabilities(5).class
    end

    test "Do my opening events starts at 9:30 and ends at 19H30 ? " do
        assert_equal DateTime.parse("2014-08-10 09:30"), availabilities(DateTime.parse("2014-08-10 09:30"))
        assert_equal DateTime.parse("2014-08-12 09:30"), availabilities(DateTime.parse("2014-08-12 09:30"))
    	   
        assert_equal DateTime.parse("2014-08-11 19:30"), availabilities(DateTime.parse("2014-08-11 19:30"))
        assert_equal DateTime.parse("2014-08-18 19:30"), availabilities(DateTime.parse("2014-08-18 19:30"))
    end


    test "When my input is an Array, do my answer is a String ?" do
        assert_equal String, availabilities(["10H30"]).class

    end


end