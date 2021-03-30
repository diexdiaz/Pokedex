#!/usr/bin/env lua5.1
--[[--
 @package   Pokedex
 @filename  src/init.lua
 @version   1.0
 @author    Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 @date		29.03.2021 13:44:55 -04
]]

package.path = package.path .. ';./?/init.lua;lib/?.lua'
require('lib.luachi')

lgi          = require 'lgi'                 -- La libreria que me permitira usar GTK

GObject      = lgi.require('GObject', '2.0') -- Parte de lgi
GLib         = lgi.GLib                      -- para el treeview
Gtk          = lgi.require('Gtk', '3.0')     -- El objeto GTK
Gdk          = lgi.require('Gdk', '3.0')
base64       = require('base64')
Gio 				 = lgi.Gio
GdkPixbuf 	 = lgi.require('GdkPixbuf', '2.0')

assert       = lgi.assert
builder      = Gtk.Builder()

assert(builder:add_from_file('../data/views/pokedex.ui'))

app          = false
ui           = builder.objects
provider	 = Gtk.CssProvider()			         -- Cargo mi css
assert(provider:load_from_path('../data/styles/custom.css'), 'ERROR: no se encontro el custom.css')
local screen
screen       = Gdk.Screen:get_default()

ui.main_window.default_width	= screen:get_width()
ui.main_window.default_height	= screen:get_height()

-- Añado mi css a la ventana actual
screen = Gdk.Display.get_default_screen(Gdk.Display:get_default())
GTK_STYLE_PROVIDER_PRIORITY_APPLICATION = 600
Gtk.StyleContext.add_provider_for_screen(
	screen, provider,
	GTK_STYLE_PROVIDER_PRIORITY_APPLICATION
)



function ui.main_window:on_destroy()				 -- que hacer cuando le den cerrar a la ventana del login
  Gtk.main_quit()
end

ui.main_window:show_all()
Gtk.main()
