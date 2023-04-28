module TEd
    class EditorPage < Gtk::Box
      type_register
  
      class << self
        def init
            set_template resource: '/com/sef-computin/ted/ui/editor_page.ui'

            bind_template_child 'editor_text_view'
            # bind_template_child 'text_view_scrollbar'
        end
      end
  
      def initialize()
        super()
        clear!
      end

      def application
        parent = self.parent
        parent = parent.parent while !parent.is_a? Gtk::ApplicationWindow
        parent.application
      end

      def clear!
        @text_file_session = TEd::TextFile.new
        editor_text_view.buffer.text = ''
      end

      def save
        @text_file_session.content = editor_text_view.buffer.text
        if @text_file_session.file_name == nil
          if @text_file_session.file_name = get_file(action: :save)
            @text_file_session.save!
            return :saved_new_file 
          end
        end
        @text_file_session.save!
      end

      def create_session_from_file
        if file_path = get_file(action: :open)
          @text_file_session = TEd::TextFile.new(path: file_path)
          editor_text_view.buffer.text = @text_file_session.content
          return true
        end
        return false
      end

      def close_session
        @text_file_session.content = editor_text_view.buffer.text

        # puts "is_new? #{@text_file_session.is_new?}"
        # puts "is_modified? #{@text_file_session.is_modified?}"

        if !@text_file_session.is_new? && !@text_file_session.is_modified?
          clear!
          return true
        end

        dialog = Gtk::Dialog.new( title: 'You sure want to close an unsaved file?',
                                  flags: Gtk::DialogFlags::MODAL,
                                  buttons: [['Save and close', Gtk::ResponseType::YES],
                                            ['Exit without saving', Gtk::ResponseType::ACCEPT],
                                            ['Cancel',  Gtk::ResponseType::CANCEL]] )
        case dialog.run
        when Gtk::ResponseType::YES
          save
          clear!
        when Gtk::ResponseType::ACCEPT
          clear!
        else
          dialog.destroy
          return false
        end
        dialog.destroy 
        return true    
      end


      def file_name
        @text_file_session.file_name
      end
      
      def get_file( action: :open )
        dialog = Gtk::FileChooserDialog.new( title: 'Choose file',
                                             action: action,
                                             buttons: [[Gtk::Stock::OK, Gtk::ResponseType::ACCEPT], [Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL]] )
        if dialog.run == Gtk::ResponseType::ACCEPT
          filename = dialog.filename
        end
        dialog.destroy
        return filename
      end
      
    end
end