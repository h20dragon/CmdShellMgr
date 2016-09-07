require 'singleton'

module CmdShellMgr


  class DSL
    include Singleton

    DSL_LIST=[
      { id: 'add', regex: Regexp.new(/^\s*(add|command)\s*\(\s*(?<id>.*)?,\s*(?<cmd>.*)\s*\)\s*$/i)},
      { id: 'execute', regex: Regexp.new(/^\s*execute\s*\(\s*(?<id>.*)?\)\s*$/i) },
      { id: 'getResult', regex: Regexp.new(/^\s*getResult[s]*\s*\(\s*(?<id>.*)?\)\s*$/i) },
      { id: 'matches', regex: Regexp.new(/^\s*getResult[s]*\s*\(\s*(?<id>.*)?\)\s*\.matches\s*\(\s*\/(?<regex>.*)?\/\s*\)$/i) },
      { id: 'capture', regex: Regexp.new(/^\s*getResult[s]*\s*\(\s*(?<id>.*)?\)\s*\.capture\s*\(\s*\/(?<regex>.*)?\/\s*\)$/i) },
      { id: 'status', regex: Regexp.new(/^\s*getResult[s]*\s*\(\s*(?<id>.*)?\)\s*\.exitStatus\s*$/i) }
    ]

    attr_accessor :queue
    attr_accessor :debug

    def validCmd?(_cmd)
      DSL_LIST.each do |c|
        _r = c[:regex]
        if _cmd.match(_r)
          return c
        end
      end

      nil
    end

    def initialize()
      @debug=false
      @queue = CmdShellMgr::Commands.new()
    end

    def count
      @queue.length
    end

    def cmd(opts)

      rc=nil
      cmdObj=nil
      _cmd=nil


      if opts.has_key?(:cmd)
        _cmd=opts[:cmd]
      else
        return false
      end

      puts "CMD => #{_cmd}" if @debug

      begin
        cmdReg     = Regexp.new(/^\s*(add|command)\s*\(\s*(?<id>.*)?,\s*(?<cmd>.*)\s*\)\s*$/i)
        executeIdReg = Regexp.new(/^\s*execute\s*\(\s*(?<id>.*)?\)\s*$/i)
        getResultsReg = Regexp.new(/^\s*getResult[s]*\s*\(\s*(?<id>.*)?\)\s*$/i)
        getResultsMatchesReg = Regexp.new(/^\s*getResult[s]*\s*\(\s*(?<id>.*)?\)\s*\.matches\s*\(\s*\/(?<regex>.*)?\/\s*\)$/i)
        getResultsCaptureReg = Regexp.new(/^\s*getResult[s]*\s*\(\s*(?<id>.*)?\)\s*\.capture\s*\(\s*\/(?<regex>.*)?\/\s*\)$/i)
        getResultsStatusReg  = Regexp.new(/^\s*getResult[s]*\s*\(\s*(?<id>.*)?\)\s*\.exitStatus\s*$/i)

        cmdObj = _cmd.match(cmdReg)

        if cmdObj

          puts __FILE__ + (__LINE__).to_s + " cmdObj => #{cmdObj.class}"  if @debug  # MatchData

          cmd = CmdShellMgr::Command.new(cmdObj[:cmd]);
          puts __FILE__ + (__LINE__).to_s + " cmd ==> #{cmd}" if @debug

          rc=@queue.add(cmdObj[:id], cmd)

        elsif _cmd.match(executeIdReg)

          cmdObj = _cmd.match(executeIdReg)
          puts __FILE__ + (__LINE__).to_s + " exe => #{cmdObj[:id]}" if @debug

          rc=@queue.execute(cmdObj[:id])

          puts __FILE__ + (__LINE__).to_s + " executeResults => #{rc}"

        elsif _cmd.match(getResultsStatusReg)
          cmdObj=_cmd.match(getResultsStatusReg)
          rc = @queue.exitStatus(cmdObj[:id])
          puts __FILE__ + (__LINE__).to_s + " exitStatus(#{_cmd}) : #{rc}"  if @debug


        elsif _cmd.match(getResultsMatchesReg)
          cmdObj = _cmd.match(getResultsMatchesReg)
          _result = @queue.results(cmdObj[:id])
          regex = cmdObj[:regex]

          rc=false

          if _result.is_a?(String)
            m=_result.match(/#{regex.to_s}/m)
            rc = m.is_a?(MatchData) && m.size > 0
          end


        elsif _cmd.match(getResultsCaptureReg)
          cmdObj = _cmd.match(getResultsCaptureReg)
          _result=@queue.results(cmdObj[:id])
          regex = cmdObj[:regex]
          puts __FILE__ + (__LINE__).to_s + "RESULTS.Capture => #{_result.class} with #{regex}" if @debug

          m=nil
          if _result.is_a?(String)
            m = _result.match(/#{regex.to_s}/m)

            puts __FILE__ + (__LINE__).to_s + " m => #{m.class}" if @debug

            if m.is_a?(MatchData) && m.size > 0
              puts __FILE__ + (__LINE__).to_s + " ====> #{m[1]}"  if @debug
              rc=m[1]
            end

          end

        elsif _cmd.match(getResultsReg)

          cmdObj=_cmd.match(getResultsReg)
          rc=@queue.results(cmdObj[:id])
          puts __FILE__ + (__LINE__).to_s + "RESULTS => #{rc}" if @debug

        else
          puts __FILE__ + (__LINE__).to_s + " Unknown command: #{_cmd}"
        end

      rescue RegexpError => ex
        puts __FILE__ + (__LINE__).to_s + "  #{ex.class} : #{_cmd}"
      end

      rc
    end


  end


end
