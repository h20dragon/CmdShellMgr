require 'spec_helper'



describe CmdShellMgr do


  it 'should add 1 command' do
    cmds = CmdShellMgr::DSL.instance.cmd(:cmd => "command(tmp, ls)")
    puts __FILE__ + (__LINE__).to_s + " cmds => #{cmds}"
    expect(CmdShellMgr::DSL.instance.count==1).to be true
  end

  it 'should define DSL exe' do
    cmds = CmdShellMgr::DSL.instance.cmd(:cmd => "execute(tmp)")
    expect(CmdShellMgr::DSL.instance.count==1).to be true
  end

  it 'should define DSL exe' do
    cmds = CmdShellMgr::DSL.instance.cmd(:cmd => "getResults(tmp)")
    puts __FILE__ + (__LINE__).to_s + " Results => #{cmds}"
    expect(CmdShellMgr::DSL.instance.count==1).to be true
  end

  it 'should capture string' do
    m1=CmdShellMgr::DSL.instance.cmd(:cmd => 'getResult(tmp).capture(/^(README\.md)$/)')
    expect(m1=='README.md').to be true
  end

  it 'should verify matches fcn' do
    m1=CmdShellMgr::DSL.instance.cmd(:cmd => 'getResult(tmp).matches(/^(xREADME\.md)$/)')
    m2=CmdShellMgr::DSL.instance.cmd(:cmd => 'getResult(tmp).matches(/^(README\.md)$/)')
    expect(!m1 && m2).to be true
  end

  it 'should add second command' do
    cmds = CmdShellMgr::DSL.instance.cmd(:cmd => "add(whoami, echo 'H20Dragon')");
    expect(CmdShellMgr::DSL.instance.count==2).to be true
  end

  it 'unexecuted test should return result set to emtpy string' do
    cmd = CmdShellMgr::DSL.instance.cmd(:cmd => 'getResults(whoami)')
    expect(cmd.is_a?(String) && cmd.empty?).to be true
  end

  it 'execute n-th command' do
    CmdShellMgr::DSL.instance.cmd(:cmd => 'execute(whoami)')
    cmd = CmdShellMgr::DSL.instance.cmd(:cmd => 'getResults(whoami)')
    puts __FILE__ + (__LINE__).to_s + " results => #{cmd}"
  end

  it 'should get exit status' do
    rc=CmdShellMgr::DSL.instance.cmd(:cmd => 'getResults(whoami).exitStatus')
    puts __FILE__ + (__LINE__).to_s + " exitStatus: #{rc}"
  end

  it 'retrieve n-th result' do
    m1=CmdShellMgr::DSL.instance.cmd(:cmd => 'getResult(whoami).capture(/^.*(Dragon)$/)')
    m2=CmdShellMgr::DSL.instance.cmd(:cmd => 'getResult(whoami).capture(/^(.*)Dragon$/)')

    expect(m1=='Dragon' && m2=='H20').to be true

  end

  it 'verify invalid cmd' do
    r=CmdShellMgr::DSL.instance.validCmd?('xgetResult(whoami)')
    expect(r).to be nil
  end

  it 'verify valid cmd' do
    r=CmdShellMgr::DSL.instance.validCmd?('getResult(whoami)')
    expect(r.is_a?(Hash)).to be true
  end

end
