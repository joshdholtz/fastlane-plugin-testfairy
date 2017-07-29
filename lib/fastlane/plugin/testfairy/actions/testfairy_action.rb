module Fastlane
  module Actions
    module SharedValues
      TESTFAIRY_BUILD_INFORMATION = :TESTFAIRY_BUILD_INFORMATION
      TESTFAIRY_DOWNLOAD_LINK = :TESTFAIRY_DOWNLOAD_LINK
    end

    class TestfairyAction < Action
      def self.run(params)
        require 'rest-client'

        resp = RestClient.post "https://app.testfairy.com/api/upload", api_key: params[:api_key], file: File.new(params[:ipa])
        json = JSON.parse resp

        Actions.lane_context[SharedValues::TESTFAIRY_BUILD_INFORMATION] = json
        Actions.lane_context[SharedValues::TESTFAIRY_DOWNLOAD_LINK] = json['build_url']
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Upload an IPA to TestFairy"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :api_key,
                                       env_name: "TESTFAIRY_API_KEY",
                                       description: "API KEY for TestFairyAction",
                                       verify_block: proc do |value|
                                          raise "No API key for TestFairyAction given, pass using `api_key: 'key'`".red unless (value and not value.empty?)
                                       end),
          FastlaneCore::ConfigItem.new(key: :ipa,
                                       env_name: "TESTFAIRY_IPA_PATH",
                                       description: "Path to your IPA file. Optional if you use the `gym` or `xcodebuild` action. For Mac zip the .app. For Android provide path to .apk file",
                                       default_value: Actions.lane_context[SharedValues::IPA_OUTPUT_PATH],
                                       verify_block: proc do |value|
                                          raise "Couldn't find ipa file at path '#{value}'".red unless File.exist?(value)
                                       end),
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['TESTFAIRY_BUILD_INFORMATION', 'The newly generated download link for this build'],
          ['TESTFAIRY_DOWNLOAD_LINK', 'Contains all keys/values from the TestFairy API (status, app_name, app_version, file_size, build_url, instrumented_url, invite_testers_url, icon_url)']
        ]
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["@joshdholtz"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
