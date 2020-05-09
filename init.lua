#!/usr/bin/env lua5.1
package.path  =  package.path .. "libraries/?.lua;vendor/?.lua";
require('libraries.luachi')

local lgi				 	= require 'lgi'									-- La libreria que me permitira usar GTK

local GObject 			 	= lgi.GObject									-- Parte de lgi
local GLib 				 	= lgi.GLib										-- para el treeview
local Gtk 				 	= lgi.require('Gtk', '3.0')						-- El objeto GTK

local assert 			 	= lgi.assert
local builder 			 	= Gtk.Builder()

assert(builder:add_from_file('vistas/pokedex.ui'))
local app_run 			 	= false
local ui 				 	= builder.objects

local main_window  		 	= ui.main_window								-- esta seria la vetana de el main de la pokédex
local especies_window		= ui.especies_window							-- esta seria la vetana para insertar una especie en la pokédex
local about_window  	 	= ui.about_window								-- esta seria la vetana de el about de la pokédex
local btn_about    		 	= builder:get_object ('btn_about')				-- este seria el boton de el about de la pokédex
local input_nombre  	 	= builder:get_object ('input_nombre')			-- esta seria la entrada de el nombre de el pokémon
local select_especie 	 	= builder:get_object ('select_especie')			-- esta seria el selector de la especie de el pokémon
local btn_agregar_especie	= builder:get_object ('btn_agregar_especie')	-- este seria el boton para añadir una nueva especie a la pokédex
local input_altura 		 	= builder:get_object ('input_altura')			-- esta seria la entrada de la altura de el pokémon
local select_habitat 	 	= builder:get_object ('select_habitat')			-- esta seria el selector de el habitat del pokémon
local input_peso 		 	= builder:get_object ('input_peso')				-- esta seria la entrada de el peso de el pokémon
local select_region 	 	= builder:get_object ('select_region')			-- este seria el selector de la región del pokémon
local select_tipo1 		 	= builder:get_object ('select_tipo1')			-- este seria el selector de el primer tipo del pokémon
local select_tipo2   	 	= builder:get_object ('select_tipo2')			-- este seria el selector de el segundo tipo del pokémon
local select_imagen 	 	= builder:get_object ('select_imagen')			-- este seria el selector de la imagen de el pokémon
local description_buffer 	= builder:get_object ('description_buffer')		-- esta seria la entrada de la descripción de el pokémon
local btn_cancelar  	 	= builder:get_object ('btn_cancelar')			-- este seria el boton de cancelar de la pokédex
local btn_guardar 		 	= builder:get_object ('btn_guardar')			-- este seria el boton de guardar de la pokédex
local input_insert_especie 	= builder:get_object ('input_insert_especie')	-- esta seria la entrada de la especie de el pokémon
local btn_cancelar_especie 	= builder:get_object ('btn_cancelar_especie')	-- este seria el boton de cancelar de la ventana para insertar una especie en la pokédex
local btn_guardar_especie 	= builder:get_object ('btn_guardar_especie')	--- este seria el boton de agregar de la ventana para insertar una especie en la pokédex
local label_especie 		= builder:get_object ('label_especie')
local label_pokedex 		= builder:get_object ('label_pokedex')

local function pokemon_exist (pokemon)
    db:open()
	local sql	= "select nombre from pokemon where nombre = %s"
    local resultado = db:get_var(sql, pokemon)
    if (resultado) then
        return true
    else
        return false
    end
end

local nombre	  = input_nombre.text
local altura	  = input_altura.text
local peso		  = input_peso.text
local descripcion = description_buffer.text

function insertar_pokemon()
	db:open()
	local sql	= [[
		insert into pokemon (nombre, altura, peso, descripcion)
		values (%s,%s,%s,%s)
	]]
	local values = {nombre, altura, peso, descripcion}

	if nombre ~= "" and altura ~= ""  and peso ~= "" and descripcion ~= "" then
        if (especie_exist(nombre) == true )then
            label_pokedex.label = "El pokémon ya existe"
            return false
        end
		if (db:execute(sql, values) == false) then
			label_pokedex.label = "Error al insertar los datos"
			print(sql, values)
		else
			nombre		= ""
			altura		= ""
			peso		= ""
			descripcion	= ""

			label_pokedex.label = "Guardado correctamente"
		end
	else
		label_pokedex.label = "Error campos vacios"
	end
 end

function get_habitat()
    select_habitat:remove_all()
    db:open()
    local sql = 'select * from habitats'
    local results = db:get_results(sql)
    -- db:close()
    for _, item in ipairs(results) do
        --print(item.habitat, item.id_habitat)
        select_habitat:append(
			item.id_habitat,
	        item.habitat
        )
    end
end

function get_especie()
    select_especie:remove_all()
    db:open()
    local sql = 'select * from especies order by id_especie desc'
    local results = db:get_results(sql)
    -- db:close()
    for _, item in ipairs(results) do
        --print(item.habitat, item.id_habitat)
        select_especie:append(
			item.id_especie,
	        item.especie
        )
    end
end

function get_region()
    select_region:remove_all()
    db:open()
    local sql = 'select * from regiones'
    local consulta = db:get_results(sql)
    -- db:close()
    for _, item in pairs(consulta) do
        -- print(item.habitat, item.id_habitat)
        select_region:append(
			item.id_region,
	        item.region
        )
    end
end

function get_tipos()
    select_tipo1:remove_all() -- limpio el primer selector
    select_tipo2:remove_all() -- limpio el segundo selector
    select_tipo2:append('','NINGUNO.')
    db:open() 					-- abro la base dedatos
    local sql = 'select * from tipos' -- la consulta sql
    local consulta = db:get_results(sql) -- ejecuto la consulta sql
    -- db:close()   -- cierro la base de datos
    for _, item in pairs(consulta) do   -- recorro el resultado de la consulta sql
        --relleno el primer selector de tipos
        select_tipo1:append(
			item.id_tipo,
	        item.tipo
        )
        --relleno el segundo selector de tipos
        select_tipo2:append(
			item.id_tipo,
	        item.tipo
        )
    end
end

get_especie()
get_habitat()
get_region()
get_tipos()

local function especie_exist (especie)
    db:open()
	local sql	= 'select especie from especies where especie = %s'
    local resultado = db:get_var(sql, especie)
    -- db:close()
    if (resultado) then
        return true
    else
        return false
    end
end


function insert_especie()
	db:open()
	local sql	= [[
		insert into especies (especie)
		values (%s)
	]]
	if input_insert_especie.text ~= "" then
        if (especie_exist(input_insert_especie.text) == true )then
            label_especie.label = "La especie ya existe"
            return false
        end
		if (db:execute(sql, input_insert_especie.text) == false) then
			label_especie.label = "Error al insertar los datos"
			print(sql)
		else
			input_insert_especie.text = ""
			label_especie.label = "Guardado correctamente"
			get_especie()
		end
	else
		label_especie.label = "Error campos vacios"
	end
	-- db:close()
end

function btn_guardar:on_clicked()										-- que hacer cuando se presione el boton guardar
	insertar_pokemon()
	print(description_buffer.text)
end

function main_window:on_destroy()										-- que hacer cuando le den cerrar a la ventana del login
  Gtk.main_quit()
end

function btn_cancelar_especie:on_clicked()								-- que hacer cuando le den al boton cancelar a la ventana de insertar especie
  ui.especies_window:hide()
end

function btn_cancelar:on_clicked()										-- que hacer cuando le den al boton de cancelar de la ventana pokedex
  Gtk.main_quit()
end

function btn_guardar_especie:on_clicked()								-- que hacer cuando presionen el boton guardar de la ventana insertar especie
	insert_especie()
end

function btn_agregar_especie:on_clicked()								-- que hacer cuando le den al boton agregar de la ventana pokedex
    ui.especies_window:run()
    ui.especies_window:hide()
    label_especie.label = ''
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
