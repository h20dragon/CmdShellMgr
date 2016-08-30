require 'spec_helper'

describe CmdShellMgr do
  it 'has a version number' do
    expect(CmdShellMgr::VERSION).not_to be nil
  end


  it 'should create Cmd object' do
    cmd = CmdShellMgr::Command.new()
    expect(cmd.is_a?(CmdShellMgr::Command)).to be true
  end

end
