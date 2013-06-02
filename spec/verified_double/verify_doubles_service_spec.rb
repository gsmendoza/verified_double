require 'verified_double/verify_doubles_service'

describe VerifiedDouble::VerifyDoublesService do
  let(:world) { double('VerifiedDouble::World') }

  subject { described_class.new(world) }

  describe "#execute" do
    it "should output the unverified_method_signatures of the world if there are any" do
      world.should_receive(:unverified_method_signatures).and_return(["Flight.find(Hash)=>Flight"])
      subject.should_receive("puts")

      subject.execute
    end

    it "should do nothing if there are no unverified_method_signatures" do
      world.should_receive(:unverified_method_signatures).and_return([])
      subject.should_not_receive("puts")

      subject.execute
    end
  end
end

