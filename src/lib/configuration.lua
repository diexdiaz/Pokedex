--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

------------
-- Conf Luachi.
-- Esta clase lee la configuracion y la devuelve
-- para su consumo en Luachi
-- @classmod configuration
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)


local configuration	= class('configuration')
------------------------------------------------------------------------
--- Lee el archivo de configuracion y lo
-- devuelve en una tabla consumible, si no encuentra el archivo .ini
-- devuelve una tabla vacia
------------------------------------------------------------------------
function configuration:get_conf()
	local file	= ml.exists(('%s/luachi.ini'):format(root))
	if (file) then
		return inifile:load(file)
	end
	return {}
end

------------------------------------------------------------------------
--- Lee el archivo de modulos y lo
-- devuelve en una tabla consumible, si no encuentra el archivo .json
-- devuelve una tabla vacia
------------------------------------------------------------------------
function configuration:get_modules()
	local file = ml.exists(('%s/../modules.json'):format(root))
	if (file) then
		local fd = io.open(file, "r")
		local modules = fd:read("*all")
		fd:close()
		return json:decode(modules)
	end
	return {}
end

return configuration
