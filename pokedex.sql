/**!
 * @package   	Pokedex
 * @filename  	pokedex.sql
 * @version   	1.0
 * @autor     	Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 * @contributor Díaz Urbaneja Víctor Diex Gamar	<Sirkennov@outlook.com>
 * @date      	04.05.2020 14:44:22 -04
 */

pragma foreign_keys = on;

drop table if exists tipos;
create table tipos (
	id_tipo integer primary key AUTOINCREMENT,
	tipo	varchar
);

-- Insertando los tipos de pokemon

insert into tipos (tipo) values
('VOLADOR.'),
('LUCHA.'),
('PLANTA.'),
('FUEGO.'),
('AGUA.'),
('ROCA.'),
('ACERO.'),
('PSÍQUICO.'),
('FANTASMA.'),
('SINIESTRO.'),
('DRAGÓN.'),
('NORMAL.'),
('VENENO.'),
('TIERRA.'),
('ELÉCTRICO.'),
('HIELO.')
('BICHO.');

drop table if exists especies;
create table especies (
	id_especie 	integer primary key AUTOINCREMENT,
	especie		varchar
);

drop table if exists pokemon;
create table pokemon (
	id_pokemon 	integer primary key AUTOINCREMENT,
	nombre		varchar,
	id_especie	integer not null,
	altura		varchar,
	peso		varchar,
	id_tipo		varchar,
	descripcion	varchar,
	foreign key ( id_especie ) references especies ( id_especie ),
	foreign key (id_tipo     ) references tipos    (id_tipo     )
);
