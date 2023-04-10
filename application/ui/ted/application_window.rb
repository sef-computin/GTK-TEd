# require_relative 'application.rb'

require_relative "#{Dir.pwd}/application/models/text_file.rb" 

module TEd 
      
    class ApplicationWindow < Gtk::ApplicationWindow
        type_register
  
        DEFAULT_SIZE = {width: 300, height: 60}
    
        class << self
          def init
            # Set the template from the resources binary
            set_template resource: '/com/sef-computin/ted/ui/application_window.ui'

            bind_template_child 'buttons_revealer'
            bind_template_child 'text_view_revealer'
            bind_template_child 'button_new'
            bind_template_child 'main_text_view'
            bind_template_child 'button_save'
            bind_template_child 'button_close'
            bind_template_child 'button_open'
          end
        end
    
        def initialize(application)
          super application: application
    
          set_title '[T]ext [ED]itor'

          reveal_editor(visible: false)

          button_new.signal_connect 'clicked' do
            set_title '[TED] - Untitled document'
            @text_file_session = TEd::TextFile.new
            main_text_view.buffer.text = ''
            reveal_editor(visible: true)
          end

          button_open.signal_connect 'clicked' do
            if file_path = get_file(action: :open)
              @text_file_session = TEd::TextFile.new(path: file_path)
              main_text_view.buffer.text = @text_file_session.content
              reveal_editor(visible: true)

              set_title "[TED] - #{File.basename(@text_file_session.file_name)}"
            end
          end

          button_close.signal_connect 'clicked' do
            set_title '[T]ext [ED]itor'

            reveal_editor(visible: false)
            @text_file_session = nil if @text_file_session != nil
          end

          button_save.signal_connect 'clicked' do
            @text_file_session.content = main_text_view.buffer.text
            
            if @text_file_session.file_name == nil
              @text_file_session.file_name = get_file(action: :save) 
              set_title "[TED] - #{File.basename(@text_file_session.file_name)}"
            end
            @text_file_session.save!
          end
          # set_default_size DEFAULT_SIZE[:width], DEFAULT_SIZE[:height]
        end

        def reveal_editor(visible: true)
          text_view_revealer.set_reveal_child visible
          buttons_revealer.set_reveal_child visible

          if !visible
            resize DEFAULT_SIZE[:width], DEFAULT_SIZE[:height]
          end
        end

        def get_file( action: :open )
          dialog = Gtk::FileChooserDialog.new( title: 'Choose file',
                                               action: action,
                                               buttons: [[Gtk::Stock::OPEN, Gtk::ResponseType::ACCEPT], [Gtk::Stock::CANCEL, Gtk::ResponseType::CANCEL]] )
          if dialog.run == Gtk::ResponseType::ACCEPT
            filename = dialog.filename
          end
          dialog.destroy
          return filename
        end
    end
end
    