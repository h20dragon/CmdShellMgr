

module CmdShellMgr


  class Command

    attr_accessor :cmd
    attr_accessor :results
    attr_accessor :exitStatus

    def initialize(_c=nil)
      @exitStatus=nil
      @cmd=_c
    end


    def execute(opts=nil)
      @results=nil

      if @cmd.match(/.*\.(sh|ksh|csh)\s*$/i)
        puts " execute script  #{@cmd} #{opts.to_s}"
        @results = %x[ #{@cmd} #{opts.to_s} ]
      else
        @results = %x[ #{@cmd} #{opts.to_s} ]
      end
      @exitStatus = $?.exitstatus

      puts "results => #{@results}"
      puts "exist   => #{@exitStatus}"
    end

    def results
      @results
    end

  end


end