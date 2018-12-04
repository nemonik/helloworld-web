describe docker_container(name: 'helloworld-web') do
  it { should exist }
  it { should be_running }
  its('repo') { should eq 'nemonik/helloworld-web' }
  its('ports') { should eq '0.0.0.0:3000->3000/tcp' }
  its('command') { should eq '/app/helloworld-web' }
end
