require 'spec_helper'

describe CmdShellMgr do


  it 'should create Cmd object' do
    cmd = CmdShellMgr::Commands.new()
    expect(cmd.is_a?(CmdShellMgr::Commands)).to be true
  end

  it 'should define Command with ls' do
    cmds = CmdShellMgr::Commands.new()
    cmds.add("ls", "ls -lt")
    cmds.execute

    puts "RESULTS => "
    puts cmds.results("ls")
  end

end
