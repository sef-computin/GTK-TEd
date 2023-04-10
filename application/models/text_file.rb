module TEd

    class TextFile

        attr_accessor :content, :file_name

        def initialize(options = {})
            if @file_name = options[:path]
                file = File.open(@file_name, 'r')
                @content = file.read
                file.close
            end
        end

        def save!
            if @file_name != nil
                file = File.open(@file_name, 'w')
                file.write @content.to_s
                file.close
            end
        end
        
    end
end