


module CmdShellMgr


  class Commands

    attr_reader :debug
    attr_accessor :queue


    def initialize()
      @debug=true
      @queue=[]
    end

    def add(_id, _cmd)
      @queue << { :id => _id, :cmd => CmdShellMgr::Command.new(_cmd) }
    end

    def execute()
      @queue.each do |_cmd|

        puts __FILE__ + (__LINE__).to_s + " execute command #{_cmd[:id]}" if @debug
        _cmd[:cmd].execute()
      end
    end

    def results(_id)
      @queue.select { |cmd| cmd[:id]==_id }
    end

  end


end

