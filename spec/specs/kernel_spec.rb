describe Kernel do
  it "should be able to create a new fake using the kernel exposed method" do
    fake.class.should == DevelopWithPassion::Fakes::Fake 
  end
end

