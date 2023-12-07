require 'gtk3'
require 'fileutils'

# application_root_path = File.expand_path(__dir__)
application_root_path = File.dirname(__FILE__)

Dir[application_root_path+"/application/ui/ted/*"].each {|file| require file }

resource_xml = File.join(application_root_path, 'resources', 'gresources.xml')
resource_bin = File.join(application_root_path, 'resources', 'gresource.bin')


system("glib-compile-resources", "--target", resource_bin, "--sourcedir", File.dirname(resource_xml), resource_xml)

resource = Gio::Resource.load(resource_bin)
Gio::Resources.register(resource)

at_exit do
  # Before existing, please remove the binary we produced, thanks.
  FileUtils.rm_f(resource_bin)
end

app = TEd::Application.new
puts app.run