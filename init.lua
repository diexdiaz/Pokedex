#!/usr/bin/env lua5.1
local lgi				= require 'lgi'									-- La libreria que me permitira usar GTK
local db				= require 'lib.db'								-- La libreria que me permitira acceder a la base de datos

local GObject 			= lgi.GObject									-- Parte de lgi
local GLib 				= lgi.GLib										-- para el treeview
local Gtk 				= lgi.require('Gtk', '3.0')						-- El objeto GTK

local assert 			= lgi.assert
local builder 			= Gtk.Builder()

assert(builder:add_from_file('vistas/pokedex.ui'))
local app_run 			= false
local ui 				= builder.objects

local main_window  		= ui.main_window								-- esta seria la vetana de el main de la pokédex
local about_window  	= ui.about_window								-- esta seria la vetana de el about de la pokédex
local btn_about    		= builder:get_object('btn_about')				-- este seria el boton de el about de la pokédex
local entry_nombre  	= builder:get_object('entry_nombre')			-- esta seria la entrada de el nombre de el pokémon
local entry_especie 	= builder:get_object ('entry_especie')			-- esta seria la entrada de la especie de el pokémon
local entry_altura 		= builder:get_object ('entry_altura')			-- esta seria la entrada de la altura de el pokémon
local entry_habitat 	= builder:get_object ('entry_habitat')			-- esta seria el input para seleccionar el habitat del pokémon
local entry_peso 		= builder:get_object ('entry_peso')				-- esta seria la entrada de el peso de el pokémon
local entry_region 		= builder:get_object ('entry_region')			-- este seria el input para seleccionar la región del pokémon
local entry_tipo1 		= builder:get_object ('entry_tipo1')			-- este seria el input para seleccionar el primer tipo del pokémon
local entry_tipo2   	= builder:get_object ('entry_tipo2')			-- este seria el input para seleccionar el segundo tipo del pokémon
local select_imagen 	= builder:get_object('select_imagen')			-- este seria el input para seleccionar la imagen de el pokémon
local entry_descripcion = builder:get_object ('entry_descripcion')		-- esta seria la entrada de la descripción de el pokémon
local btn_cancelar  	= builder:get_object('btn_cancelar')			-- este seria el boton de cancelar de la pokédex
local btn_editar 		= builder:get_object('btn_editar')				-- este seria el boton de editar de la pokédex
local btn_guardar 		= builder:get_object('btn_guardar')				-- este seria el boton de guardar de la pokédex






function btn_guardar:on_clicked()										-- que hacer cuando se presione el boton guardar
	insert_data()
end

function main_window:on_destroy()										-- que hacer cuando le den cerrar a la ventana del login
  Gtk.main_quit()
end

function btn_cancelar:on_clicked()										-- que hacer cuando le den al boton de cerrar de el login
  Gtk.main_quit()
end

function btn_about:on_clicked()											-- que hacer cuando le den al boton de about de el login
    ui.about_window:run()
    ui.about_window:hide()
end

main_window:show_all()
Gtk.main()




