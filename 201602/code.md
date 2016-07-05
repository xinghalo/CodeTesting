```
        @inputs = []
        @filters = []
        @outputs = []
        @periodic_flushers = []
        @shutdown_flushers = []

          @input_file_1 = plugin("input", "file", LogStash::Util.hash_merge_many({ "type" => ("test042703") }, { "path" => ("E:\\日志数据\\USER1.log") }, { "start_position" => ("beginning") }, { "add_field" => {("source") => ("USER1.log"), ("sourcetype") => ("test042703"), ("host") => ("XINGHL")} }))

          @inputs << @input_file_1

          @filter_kv_2 = plugin("filter", "kv", LogStash::Util.hash_merge_many({ "source" => ("message") }, { "field_split" => ("\\, ") }))

          @filters << @filter_kv_2

            @filter_kv_2_flush = lambda do |options, &block|
              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_kv_2)

              events = @filter_kv_2.flush(options)

              return if events.nil? || events.empty?

              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_kv_2, :events => events)

                          events = @filter_grok_3.multi_filter(events)
  
            events = @filter_grok_4.multi_filter(events)
  
            events = cond_func_1(events)
  
            events = @filter_kv_8.multi_filter(events)
  
            events = @filter_grok_9.multi_filter(events)
  


              events.each{|e| block.call(e)}
            end

            if @filter_kv_2.respond_to?(:flush)
              @periodic_flushers << @filter_kv_2_flush if @filter_kv_2.periodic_flush
              @shutdown_flushers << @filter_kv_2_flush
            end

          @filter_grok_3 = plugin("filter", "grok", LogStash::Util.hash_merge_many({ "break_on_match" => ("false") }, { "match" => {("message") => ("^[^=]+=(?<test1>[A-Za-z]+)")} }))

          @filters << @filter_grok_3

            @filter_grok_3_flush = lambda do |options, &block|
              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_grok_3)

              events = @filter_grok_3.flush(options)

              return if events.nil? || events.empty?

              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_grok_3, :events => events)

                          events = @filter_grok_4.multi_filter(events)
  
            events = cond_func_2(events)
  
            events = @filter_kv_8.multi_filter(events)
  
            events = @filter_grok_9.multi_filter(events)
  


              events.each{|e| block.call(e)}
            end

            if @filter_grok_3.respond_to?(:flush)
              @periodic_flushers << @filter_grok_3_flush if @filter_grok_3.periodic_flush
              @shutdown_flushers << @filter_grok_3_flush
            end

          @filter_grok_4 = plugin("filter", "grok", LogStash::Util.hash_merge_many({ "break_on_match" => ("false") }, { "match" => {("message") => ("^[^=]+=(?<test2>[A-Za-z]+)")} }))

          @filters << @filter_grok_4

            @filter_grok_4_flush = lambda do |options, &block|
              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_grok_4)

              events = @filter_grok_4.flush(options)

              return if events.nil? || events.empty?

              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_grok_4, :events => events)

                          events = cond_func_3(events)
  
            events = @filter_kv_8.multi_filter(events)
  
            events = @filter_grok_9.multi_filter(events)
  


              events.each{|e| block.call(e)}
            end

            if @filter_grok_4.respond_to?(:flush)
              @periodic_flushers << @filter_grok_4_flush if @filter_grok_4.periodic_flush
              @shutdown_flushers << @filter_grok_4_flush
            end

          @filter_grok_5 = plugin("filter", "grok", LogStash::Util.hash_merge_many({ "break_on_match" => ("false") }, { "match" => {("message") => ("^[^=]+=(?<test3>[A-Za-z]+)")} }))

          @filters << @filter_grok_5

            @filter_grok_5_flush = lambda do |options, &block|
              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_grok_5)

              events = @filter_grok_5.flush(options)

              return if events.nil? || events.empty?

              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_grok_5, :events => events)

                          events = @filter_kv_8.multi_filter(events)
  
            events = @filter_grok_9.multi_filter(events)
  


              events.each{|e| block.call(e)}
            end

            if @filter_grok_5.respond_to?(:flush)
              @periodic_flushers << @filter_grok_5_flush if @filter_grok_5.periodic_flush
              @shutdown_flushers << @filter_grok_5_flush
            end

          @filter_grok_6 = plugin("filter", "grok", LogStash::Util.hash_merge_many({ "break_on_match" => ("false") }, { "match" => {("message") => ("^[^=]+=(?<test4>[A-Za-z]+)")} }))

          @filters << @filter_grok_6

            @filter_grok_6_flush = lambda do |options, &block|
              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_grok_6)

              events = @filter_grok_6.flush(options)

              return if events.nil? || events.empty?

              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_grok_6, :events => events)

                          events = @filter_grok_7.multi_filter(events)
  
            events = @filter_kv_8.multi_filter(events)
  
            events = @filter_grok_9.multi_filter(events)
  


              events.each{|e| block.call(e)}
            end

            if @filter_grok_6.respond_to?(:flush)
              @periodic_flushers << @filter_grok_6_flush if @filter_grok_6.periodic_flush
              @shutdown_flushers << @filter_grok_6_flush
            end

          @filter_grok_7 = plugin("filter", "grok", LogStash::Util.hash_merge_many({ "break_on_match" => ("false") }, { "match" => {("message") => ("^[^=]+=(?<test5>[A-Za-z]+)")} }))

          @filters << @filter_grok_7

            @filter_grok_7_flush = lambda do |options, &block|
              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_grok_7)

              events = @filter_grok_7.flush(options)

              return if events.nil? || events.empty?

              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_grok_7, :events => events)

                          events = @filter_kv_8.multi_filter(events)
  
            events = @filter_grok_9.multi_filter(events)
  


              events.each{|e| block.call(e)}
            end

            if @filter_grok_7.respond_to?(:flush)
              @periodic_flushers << @filter_grok_7_flush if @filter_grok_7.periodic_flush
              @shutdown_flushers << @filter_grok_7_flush
            end

          @filter_kv_8 = plugin("filter", "kv", LogStash::Util.hash_merge_many({ "source" => ("message") }, { "field_split" => ("\\, ") }))

          @filters << @filter_kv_8

            @filter_kv_8_flush = lambda do |options, &block|
              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_kv_8)

              events = @filter_kv_8.flush(options)

              return if events.nil? || events.empty?

              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_kv_8, :events => events)

                          events = @filter_grok_9.multi_filter(events)
  


              events.each{|e| block.call(e)}
            end

            if @filter_kv_8.respond_to?(:flush)
              @periodic_flushers << @filter_kv_8_flush if @filter_kv_8.periodic_flush
              @shutdown_flushers << @filter_kv_8_flush
            end

          @filter_grok_9 = plugin("filter", "grok", LogStash::Util.hash_merge_many({ "break_on_match" => ("false") }, { "match" => {("message") => ("^[^=]+=(?<test6>[A-Za-z]+)")} }))

          @filters << @filter_grok_9

            @filter_grok_9_flush = lambda do |options, &block|
              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_grok_9)

              events = @filter_grok_9.flush(options)

              return if events.nil? || events.empty?

              @logger.debug? && @logger.debug("Flushing", :plugin => @filter_grok_9, :events => events)

                

              events.each{|e| block.call(e)}
            end

            if @filter_grok_9.respond_to?(:flush)
              @periodic_flushers << @filter_grok_9_flush if @filter_grok_9.periodic_flush
              @shutdown_flushers << @filter_grok_9_flush
            end

          @output_stdout_10 = plugin("output", "stdout", LogStash::Util.hash_merge_many({ "codec" => ("rubydebug") }))

          @outputs << @output_stdout_10

  def filter_func(event)
    events = [event]
    @logger.debug? && @logger.debug("filter received", :event => event.to_hash)
              events = @filter_kv_2.multi_filter(events)
              events = @filter_grok_3.multi_filter(events)
              events = @filter_grok_4.multi_filter(events)
              events = cond_func_4(events)
              events = @filter_kv_8.multi_filter(events)
              events = @filter_grok_9.multi_filter(events)
    
    events
  end
  def output_func(event)
    @logger.debug? && @logger.debug("output received", :event => event.to_hash)
    @output_stdout_10.handle(event)
    
  end
          def cond_func_1(input_events)
            result = []
            input_events.each do |event|
              events = [event]
              if (((event["[message]"] =~ /login/))) # if [message] =~ "login"
            events = @filter_grok_5.multi_filter(events)
  
elsif (((event["[message]"] =~ /opertion1/))) # else if [message] =~ "opertion1"
            events = @filter_grok_6.multi_filter(events)
              events = @filter_grok_7.multi_filter(events)
  

              end
              result += events
            end
            result
          end

          def cond_func_2(input_events)
            result = []
            input_events.each do |event|
              events = [event]
              if (((event["[message]"] =~ /login/))) # if [message] =~ "login"
            events = @filter_grok_5.multi_filter(events)
  
elsif (((event["[message]"] =~ /opertion1/))) # else if [message] =~ "opertion1"
            events = @filter_grok_6.multi_filter(events)
              events = @filter_grok_7.multi_filter(events)
  

              end
              result += events
            end
            result
          end

          def cond_func_3(input_events)
            result = []
            input_events.each do |event|
              events = [event]
              if (((event["[message]"] =~ /login/))) # if [message] =~ "login"
            events = @filter_grok_5.multi_filter(events)
  
elsif (((event["[message]"] =~ /opertion1/))) # else if [message] =~ "opertion1"
            events = @filter_grok_6.multi_filter(events)
              events = @filter_grok_7.multi_filter(events)
  

              end
              result += events
            end
            result
          end

          def cond_func_4(input_events)
            result = []
            input_events.each do |event|
              events = [event]
              if (((event["[message]"] =~ /login/))) # if [message] =~ "login"
            events = @filter_grok_5.multi_filter(events)
  
elsif (((event["[message]"] =~ /opertion1/))) # else if [message] =~ "opertion1"
            events = @filter_grok_6.multi_filter(events)
              events = @filter_grok_7.multi_filter(events)
  

              end
              result += events
            end
            result
          end
          ```
