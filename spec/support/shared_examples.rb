shared_examples_for "it can initialize its stack frame within a shared example" do
  it "set the stack frame of the signature's caller" do
    subject = described_class.new(attributes).tap {|method_signature|
      method_signature.method = 'do_something' }
      
    expect(subject.stack_frame.to_s)
      .to include("./spec/support/shared_examples.rb")
  end
end