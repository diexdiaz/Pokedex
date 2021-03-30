#!/usr/bin/env lua5.1
package.path  =  package.path .. "libraries/?.lua;vendor/?.lua";
require('libraries.luachi')

local lgi				 	= require 'lgi'									-- La libreria que me permitira usar GTK

local GObject 			 	= lgi.GObject									-- Parte de lgi
local GLib 				 	= lgi.GLib										-- para el treeview
local Gtk 				 	= lgi.require('Gtk', '3.0')						-- El objeto GTK
local base64				= require('base64')
local Gio 					= lgi.Gio
local GdkPixbuf 			= lgi.GdkPixbuf

local assert 			 	= lgi.assert
local builder 			 	= Gtk.Builder()

assert(builder:add_from_file('vistas/pokedex.ui'))
local app_run 			 	= false
local ui 				 	= builder.objects

function get_habitat()
    ui.select_habitat:remove_all()
    db:open()
    local sql = 'select * from habitats'
    local results = db:get_results(sql)
    -- db:close()
    for _, item in ipairs(results) do
        --print(item.habitat, item.id_habitat)
        ui.select_habitat:append(
			item.id_habitat,
	        item.habitat
        )
    end
end

function get_especie()
    ui.select_especie:remove_all()
    db:open()
    local sql = 'select * from especies order by id_especie desc'
    local results = db:get_results(sql)
    -- db:close()
    for _, item in ipairs(results) do
        --print(item.habitat, item.id_habitat)
        ui.select_especie:append(
			item.id_especie,
	        item.especie
        )
    end
end

function get_region()
    ui.select_region:remove_all()
    db:open()
    local sql = 'select * from regiones'
    local consulta = db:get_results(sql)
    -- db:close()
    for _, item in pairs(consulta) do
        -- print(item.habitat, item.id_habitat)
        ui.select_region:append(
			item.id_region,
	        item.region
        )
    end
end

function get_tipos()
    ui.select_tipo1:remove_all() -- limpio el primer selector
    ui.select_tipo2:remove_all() -- limpio el segundo selector
    ui.select_tipo2:append('0','NINGUNO.')
    db:open() 					-- abro la base dedatos
    local sql = 'select * from tipos' -- la consulta sql
    local consulta = db:get_results(sql) -- ejecuto la consulta sql
    -- db:close()   -- cierro la base de datos
    for _, item in pairs(consulta) do   -- recorro el resultado de la consulta sql
        --relleno el primer selector de tipos
        ui.select_tipo1:append(
			item.id_tipo,
	        item.tipo
        )
        --relleno el segundo selector de tipos
        ui.select_tipo2:append(
			item.id_tipo,
	        item.tipo
        )
    end
end

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


local function insert_especie()
	db:open()
	local sql	= [[
		insert into especies (especie)
		values (%s)
	]]
	if ui.input_insert_especie.text ~= "" then
        if (especie_exist(ui.input_insert_especie.text) == true )then
            ui.label_especie.label = "La especie ya existe"
            return false
        end
		if (db:execute(sql, ui.input_insert_especie.text) == false) then
			ui.label_especie.label = "Error al insertar los datos"
			print(sql)
		else
			ui.input_insert_especie.text = ""
			ui.label_especie.label = "Guardado correctamente"
			get_especie()
		end
	else
		ui.label_especie.label = "Error campos vacios"
	end
	-- db:close()
end



local function guardar_tipo (id_pokemon, id_tipo)
	db:open()
	local sql = 'insert into tipos_pokemon (id_pokemon, id_tipo) values (%d, %d)'
	return db:execute(sql, id_pokemon, id_tipo)
end

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

-- ui.select_imagen:add_filter(ui.filter_png)
local image_b64 = nil
function ui.select_imagen:on_selection_changed()
	local dir_img = ui.select_imagen:get_filename()
	local file = io.open(dir_img, 'rb')
	local image_file = file:read('*a')
	image_b64 = base64.encode(image_file)
end

local function insertar_pokemon()
	db:open()
	local sql	= [[
		insert into pokemon(nombre, id_especie, altura, id_habitat, peso, id_region, descripcion, imagen)
		values (%s,%d,%s,%d,%s,%d,%s,%s)
	]]
	local values = {
		ui.input_nombre.text,
		ui.select_especie:get_active_id(),
		ui.input_altura.text,
		ui.select_habitat:get_active_id(),
		ui.input_peso.text,
		ui.select_region:get_active_id(),
		ui.description_buffer.text,
		image_b64
	}

	if ui.input_nombre.text ~= "" and
			ui.select_especie:get_active_id() ~= "" and
			ui.input_altura.text ~= "" and
			ui.select_habitat:get_active_id() ~= "" and
			ui.input_peso.text ~= "" and
			ui.select_region:get_active_id() ~= "" and
			ui.description_buffer.text ~= "" and
			image_b64 ~= nil
	then
        if (pokemon_exist(ui.input_nombre.text) == true) then
            ui.label_mensaje.label = "El pokémon ya existe"
            return false
        end
        local save = db:execute(sql, values)
        local id_pokemon = db:last_insert_rowid()

        if save  then
			local id_tipo1 = ui.select_tipo1:get_active_id()
			local id_tipo2= ui.select_tipo2:get_active_id()
			guardar_tipo (id_pokemon, id_tipo1)
			if tonumber(id_tipo2) ~= 0 then
				guardar_tipo (id_pokemon, id_tipo2)
			end
		end
		if ( save == false) then
			ui.label_mensaje.label = "Error al insertar los datos"
			print(sql, values)
		else
			ui.input_nombre.text			= ""
			ui.input_altura.text			= ""
			ui.input_peso.text				= ""
			ui.description_buffer.text		= ""
			ui.select_especie:remove_all()
			ui.select_habitat:remove_all()
			ui.select_region:remove_all()
			ui.label_mensaje.label = "Guardado correctamente"
		end
	else
		ui.label_mensaje.label = "Error campos vacios"
	end
 end

get_especie()
get_habitat()
get_region()
get_tipos()

--- Remueve espacios iniciales y finales de una cadena
--- @param value el texto a limpiar
--- @return el texto limpiado
function trim(value)
    return (string.gsub(value, "%s+$", ""):gsub("^%s+", ""))
end


function get_data (entry)
	db:open()
	if trim(entry) == '' then return {} end

	local sql = 'select * from pokedex where nombre like %s'
	local resultado = db:get_rows(sql, "%"..trim(entry).."%")
	if resultado then
		return resultado[1]
	end
	return {}
end

function ui.buscador:on_changed()
	local datos = get_data(ui.buscador.text)
	-- for k,v in pairs(datos) do
		-- print(k,v)
	-- end

	if (  datos  ) then
		print(  datos['nombre'] )
		ui.ft_id.label 				= '000'.. datos['num']
		ui.ft_nombre.label 			= datos['nombre']
		ui.ft_descripcion.label 	= datos['descripcion']
		ui.ft_altura.label 			= datos['altura']
		ui.ft_peso.label 			= datos['peso']
		ui.ft_tipo1.label 			= datos['tipo']
		ui.ft_tipo2.label 			= datos['tipo']
		ui.ft_region.label 			= datos['region']
		ui.ft_especie.label 		= datos['especie']
		ui.ft_habitat.label 		= datos['habitat']

	-- if (select_tipo2:append() == 'NINGUNO.') then
		-- ui.ft_tipo2.label:hide()
	-- end

		local image_decode = base64.decode(datos['imagen'])
		local stream = Gio.MemoryInputStream.new_from_data(image_decode)
		local image	 = GdkPixbuf.Pixbuf.new_from_stream(stream)
		image = image:scale_simple(256, 256, 'BILINEAR')
		ui.img_preview:set_from_pixbuf(image)
	end

end

function ui.btn_guardar:on_clicked()										-- que hacer cuando se presione el boton guardar
	insertar_pokemon()
	-- print(input_nombre.text, input_altura.text, input_peso.text, description_buffer.text)
	-- print(ui.select_region:get_active_id())
end

function ui.main_window:on_destroy()										-- que hacer cuando le den cerrar a la ventana del login
  Gtk.main_quit()
end

function ui.btn_cancelar_especie:on_clicked()								-- que hacer cuando le den al boton cancelar a la ventana de insertar especie
  ui.especies_window:hide()
end

function ui.btn_agregar_especie:on_clicked()								-- que hacer cuando le den al boton agregar de la ventana pokedex
    ui.especies_window:run()
    ui.especies_window:hide()
    ui.label_especie.label = ''
end

function ui.btn_guardar_especie:on_clicked()								-- que hacer cuando presionen el boton guardar de la ventana insertar especie
	insert_especie()
end

function ui.btn_agregar_pokemon:on_clicked()								-- que hacer cuando le den al boton de agregar del main
get_especie()
get_habitat()
get_region()
get_tipos()
    ui.pokemon_window:run()
    ui.pokemon_window:hide()
end

function ui.btn_cancelar:on_clicked ()
	ui.pokemon_window:hide()
end

function ui.btn_about:on_clicked()											-- que hacer cuando le den al boton de about del main
    ui.about_window:run()
    ui.about_window:hide()
end

function ui.btn_cerrar:on_clicked()										-- que hacer cuando le den al boton de cerrar del main
  Gtk.main_quit()
end

ui.main_window:show_all()
Gtk.main()
