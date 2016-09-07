


module CmdShellMgr


  class Commands

    attr_reader :debug
    attr_accessor :queue


    def initialize()
      @debug=false
      @queue=[]
    end

    def count
      length
    end
    def size
      length
    end
    def length
      @queue.length
    end

    def add(_id, _cmd)

      if _cmd.is_a?(String)
        @queue << { :id => _id, :cmd => CmdShellMgr::Command.new(_cmd) }
      else
        @queue << { :id => _id, :cmd => _cmd }
      end

      @queue.last()
    end

    def _execute(cmd)
      rc=nil
      if cmd.is_a?(Hash) && cmd.has_key?(:cmd) && cmd.has_key?(:id)
        rc = cmd[:cmd].execute()
      end

      rc
    end



    def execute(id=nil)

      exitStatus=0
      rc=nil

      if id.nil?
        @queue.each do |_cmd|

          puts __FILE__ + (__LINE__).to_s + " execute command #{_cmd[:id]}" if @debug
          rc=_cmd[:cmd].execute()
        end
      else
        hits = @queue.select { |cmd| cmd[:id]==id }
        hits.each do |h|
          puts __FILE__ + (__LINE__).to_s + " #{h}" if @debug
          rc=_execute(h)
        end
      end

      rc
    end

    def exitStatus(_id)
      puts __FILE__ + (__LINE__).to_s + " results(#{_id})" if @debug
      rc=""
      hits = @queue.select { |cmd| cmd[:id]==_id }
      hits.each do |h|

        puts __FILE__ + (__LINE__).to_s + " results : #{h[:cmd].exitStatus}" if @debug
        rc << h[:cmd].exitStatus.to_s
      end

      rc
    end

    def results(_id)
      puts __FILE__ + (__LINE__).to_s + " results(#{_id})" if @debug
      rc=""
      hits = @queue.select { |cmd| cmd[:id]==_id }
      hits.each do |h|

        puts __FILE__ + (__LINE__).to_s + " results : #{h[:cmd].results}" if @debug
        rc << h[:cmd].results.to_s
      end

      rc
    end

  end


end

