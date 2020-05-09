--[[
          _                     _     _
         | |   _   _  __ _  ___| |__ (_)
         | |  | | | |/ _` |/ __| '_ \| |
         | |__| |_| | (_| | (__| | | | |
         |_____\__,_|\__,_|\___|_| |_|_|
Copyright (c) 2020  Díaz  Víctor  aka  (Máster Vitronic)
<vitronic2@gmail.com>   <mastervitronic@vitronic.com.ve>
]]--

require('vendor.middleclass');
root		=( io.popen('pwd'):read('*l') );
ml 		= require('vendor.ml');
json 		= require('vendor.json');
inifile		= require("vendor.inifile");
util		= require("libraries.utils");
configuration	= require("libraries.configuration");
conf		= configuration:get_conf();
db		= require("libraries.database.database");
