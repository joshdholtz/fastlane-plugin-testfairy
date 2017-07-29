describe Fastlane::Actions::TestfairyAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The testfairy plugin is working!")

      Fastlane::Actions::TestfairyAction.run(nil)
    end
  end
end
