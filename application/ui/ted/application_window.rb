application_path = File.dirname(__FILE__)+"/../.."
require_relative "#{application_path}/models/text_file.rb" 

module TEd 
      
    class ApplicationWindow < Gtk::ApplicationWindow
        type_register
  
        DEFAULT_SIZE = {width: 400, height: 60}

        class << self
          def init
            # Set the template from the resources binary
            set_template resource: '/com/sef-computin/ted/ui/application_window.ui'

            bind_template_child 'buttons_revealer'
            bind_template_child 'editor_revealer'
            bind_template_child 'editor_notebook'
            bind_template_child 'button_new'
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
            start_session(mode: :new)
          end

          button_open.signal_connect 'clicked' do
            start_session(mode: :open)
          end

          button_close.signal_connect 'clicked' do
            current_page = editor_notebook.get_nth_page editor_notebook.current_page 
            if current_page.close_session
              editor_notebook.remove_page editor_notebook.current_page
              resolve_title editor_notebook.current_page
            end     
          end

          button_save.signal_connect 'clicked' do
            current_page = editor_notebook.get_nth_page editor_notebook.current_page 
            if current_page.save == :saved_new_file
              set_title "[TED] - #{File.basename(current_page.file_name)}"
            end
          end

          editor_notebook.signal_connect 'switch-page' do |_, current_page, page_num|
            set_title "[TED] - #{File.basename(current_page.file_name)}"
          end
        end

        def start_session(mode: :new)
            new_page = TEd::EditorPage.new(mode: mode)
            editor_notebook.append_page new_page, Gtk::Label.new("#{File.basename(new_page.file_name)}")
            editor_notebook.set_page -1
            set_title "[TED] - #{File.basename(new_page.file_name)}"

            reveal_editor(visible: true)
        end

        def resolve_title(page_num = nil)
          if page_num == -1 || page_num == nil
            set_title '[T]ext [ED]itor'
            reveal_editor(visible: false)
          else
            current_page = editor_notebook.get_nth_page editor_notebook.current_page
            set_title "[TED] - #{File.basename(current_page.file_name)}"
          end
        end

        def reveal_editor(visible: true)
          editor_revealer.set_reveal_child visible
          buttons_revealer.set_reveal_child visible
          
          resize DEFAULT_SIZE[:width], DEFAULT_SIZE[:height] if !visible
        end

        def destroy(win)
          puts "destroy"
          super
        end
        
    end
end
    