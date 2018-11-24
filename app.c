#include <gtk/gtk.h>
#include <webkit2/webkit2.h>

const int WINDOW_WIDTH = 480;
const int WINDOW_HEIGHT = 320;

static void destroyWindowCb(GtkWidget* widget, GtkWidget* window)
{
   gtk_main_quit();
}

int main(int argc, char* argv[]) {
  gtk_init(&argc, &argv);

  GtkWidget *main_window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_default_size(GTK_WINDOW(main_window), WINDOW_WIDTH, WINDOW_HEIGHT);
  g_signal_connect(main_window, "destroy", G_CALLBACK(destroyWindowCb), NULL);

  WebKitWebView *webView = WEBKIT_WEB_VIEW(webkit_web_view_new());

  gtk_container_add(GTK_CONTAINER(main_window), GTK_WIDGET(webView));

  webkit_web_view_load_uri(webView, "file:///home/cromega/code/sublimia/infoboard/web/index.html");
  gtk_widget_grab_focus(GTK_WIDGET(webView));
  gtk_widget_show_all(main_window);

  gtk_main();
  return 0;
}

