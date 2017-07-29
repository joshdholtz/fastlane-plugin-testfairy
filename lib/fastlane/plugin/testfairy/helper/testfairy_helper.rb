module Fastlane
  module Helper
    class TestfairyHelper
      # class methods that you define here become available in your action
      # as `Helper::TestfairyHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the testfairy plugin helper!")
      end
    end
  end
end
