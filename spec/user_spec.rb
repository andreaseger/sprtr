describe User do
  let(:username) { "testname" }
  let(:password) { "some%hard&^secret" }
  before :each do
    User.create username, password
  end
  it 'should save the user' do
    u=User.load(username)
    u.username.should == username
    u.password_hash.should_not be_nil
  end
  it 'should check the password' do
    u=User.load(username)
    u.password.should == password
  end
end