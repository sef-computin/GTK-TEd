require_relative 'application_window.rb'
module TEd
    class Application < Gtk::Application
        attr_reader :user_data_path

        def initialize
            super 'com.sef-computin.ted', Gio::ApplicationFlags::FLAGS_NONE

            signal_connect :activate do |app|
                window = TEd::ApplicationWindow.new(app)
                # window.set_default_size 300, 100
                window.present
            end
        end
    end

end