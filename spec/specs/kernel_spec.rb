describe Kernel do
  it "should be able to create a new fake using the kernel exposed method" do
    fake.class.should == Fakes::Fake 
  end
end

