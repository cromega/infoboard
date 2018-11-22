require "webkit2-gtk"

infoboard = Gtk::Application.new("com.cromega.infoboard", :flags_none)
infoboard.signal_connect "activate" do |app|
  window = Gtk::ApplicationWindow.new(app)
  window.set_default_size(480, 320)
  window.decorated = false

  view = WebKit2Gtk::WebView.new
  view.load_uri("file:///#{`pwd`}/web/index.html")

  window.add(view)
  window.show_all
end

infoboard.run
