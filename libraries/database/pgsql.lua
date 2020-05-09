--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

------------------------------------------------------------------------
-- PgSQL Luachi.
-- Esta clase de abstracción de base de datos contiene metodos para
-- la manipulacion facil de PostgreSQL
-- @classmod PgSQL
-- @author Máster Vitronic
-- @license GPL
-- @copyright 2020  Díaz  Víctor  aka  (Máster Vitronic)
------------------------------------------------------------------------

local db	= class('db')
--@see https://github.com/arcapos/luapgsql
local pgsql	= require('pgsql')


---conexion a la base de datos
--@param config "user=%s password=%s dbname=%s hostaddr=%s port=%d"
--@return boolean
function db:open(config)
	self.db = pgsql.connectdb(config)
	if ( self.db:status() == pgsql.CONNECTION_OK ) then
		return true
	end
	return false, self.db:errorMessage()
end

---retorna todo el objeto db
function db:raw()
    return self.db
end

---cierra la conexion
function db:close()
    self.db:finish()
end

------------------------------------------------------------------------
--- Ejecuta un query
-- @param sql el query a ser ejecutado
-- @return boolean: true si fue exitoso, false en caso contrario
------------------------------------------------------------------------
function db:exec(sql)
	return self.db:exec(sql)
end

------------------------------------------------------------------------
--- Ejecuta una consulta y retorna toda la data en una tabla
-- @param sql string: el query a ser ejecutado
-- @return table: las columnas con el resultado
------------------------------------------------------------------------
function db:get_results(sql)
	local results = self.db:exec(sql)
	local rows = {}
	for _,row in pairs(results:copy()) do
		table.insert(rows,row)
	end
	return rows
end

------------------------------------------------------------------------
--- Esta funcion retorna el ultimo rowid de la mas reciente
-- sentencia 'INSERT into' en la base de datos.
-- @return integer: el ultimo rowid
-- @todo Optimizar esto
------------------------------------------------------------------------
function db:last_insert_rowid()
	local results, err = self:get_results('select lastval();')
	if not results then
		return false, err
	end
	local result
	if next(results) then
		for _,value in pairs(results[1]) do
			result = value
		end
	end
	return result
end

------------------------------------------------------------------------
--- retorna una version limpia y desinfectada de la entrada
-- @param str string
-- @return string: la entrada escapada
------------------------------------------------------------------------
function db:escape(str)
	return self.db:escapeString(str)
end

return db
