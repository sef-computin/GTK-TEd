module TEd

    class TextFile

        attr_accessor :content, :file_name

        def initialize(options = {})
            if @file_name = options[:path]
                file = File.open(@file_name, 'r')
                @content = file.read
                file.close
            else
                @content = nil
            end
        end

        def save!
            if @file_name != nil
                file = File.open(@file_name, 'w')
                file.write @content.to_s
                file.close
            end
        end

        def is_new?
            return !File.exists?(@file_name) if @file_name != nil
            return !@content.to_s.eql?('')
        end

        def is_modified?
            if @file_name != nil
                File.open(@file_name, 'r'){|file|
                    return !file.read.eql?(@content.to_s)
                }                   
            end
            false
        end
        
    end
end