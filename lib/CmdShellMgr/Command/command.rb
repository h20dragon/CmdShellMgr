

module CmdShellMgr


  class Command

    attr_accessor :debug
    attr_accessor :cmd
    attr_accessor :results
    attr_accessor :exitStatus

    def initialize(_c=nil)
      @debug=true
      @exitStatus=nil
      @results=nil
      @cmd=_c
    end

    def instance_method
      self
    end


    def execute(opts=nil)
      @results=nil
      @exitStatus=nil

      begin
        @results = %x[ #{@cmd} #{opts.to_s} ]
        @exitStatus = $?.exitstatus
      rescue => ex
        puts __FILE__ + (__LINE__).to_s + " #{ex.class}"
        puts ex.backtrace
      end

      if @debug
        puts __FILE__ + (__LINE__).to_s + " results => #{@results}"
        puts __FILE__ + (__LINE__).to_s + " exitStatus   => #{@exitStatus}"
      end

      return self
    end

    def exitStatus
      @exitStatus
    end

    def results
      @results
    end

  end


end