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
            bind_template_child 'editor_revealer'
            # bind_template_child 'editor_subwindow'
            bind_template_child 'button_new'
            bind_template_child 'button_save'
            bind_template_child 'button_close'
            bind_template_child 'button_open'
          end
        end
    
        def initialize(application)
          super application: application
    
          set_title '[T]ext [ED]itor'

          # editor_pages = []

          editor_page = TEd::EditorPage.new
          editor_revealer.add editor_page

          reveal_editor(visible: false)

          button_new.signal_connect 'clicked' do
            # if editor_pages.is_empty?
            #   editor_pages << TEd::EditorPage.new
            # end
              if editor_page.close_session
                set_title '[TED] - Untitled document'
                reveal_editor(visible: true)
              end
          end

          button_open.signal_connect 'clicked' do
            if editor_page.close_session && editor_page.create_session_from_file
                reveal_editor(visible: true)
                set_title "[TED] - #{File.basename(editor_page.file_name)}"
            end
          end

          button_close.signal_connect 'clicked' do
            if editor_page.close_session
              set_title '[T]ext [ED]itor'
              reveal_editor(visible: false)
            end      
          end

          button_save.signal_connect 'clicked' do
            if editor_page.save == :saved_new_file
              set_title "[TED] - #{File.basename(editor_page.file_name)}"
            end
          end
        end


        def reveal_editor(visible: true)
          editor_revealer.set_reveal_child visible
          buttons_revealer.set_reveal_child visible
          
          resize DEFAULT_SIZE[:width], DEFAULT_SIZE[:height] if !visible
        end

    end
end
    