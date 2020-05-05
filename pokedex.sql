/**!
 * @package		Pokedex
 * @filename	pokedex.sql
 * @version		1.0
 * @autor		Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 * @contributor	Díaz Urbaneja Víctor Diex Gamar <Sirkennov@outlook.com>
 * @date		04.05.2020 14:44:22 -04
 */

pragma foreign_keys = on;

-- Creando la tabla tipos
drop table if exists tipos;
create table tipos (
	id_tipo	integer primary key AUTOINCREMENT,
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
('HIELO.'),
('BICHO.');

-- Creando tabla de especies
drop table if exists especies;
create table especies (
	id_especie	integer primary key AUTOINCREMENT,
	especie		varchar
);

-- Insertando las especies del pokémon
insert into especies (especie) values
('POKéMON SEMILLA'),
('POKéMON LLAMA'),
('POKéMON MARISCO'),
('POKéMON PÁJARO'),
('POKéMON SOMBRA'),
('POKéMON RELÁMPAGO');

-- Creando tabla pokemon
drop table if exists pokemon;
create table pokemon (
	id_pokemon			integer primary key AUTOINCREMENT,
	nombre				varchar,
	id_especie			integer not null,
	altura				varchar,
	peso				varchar,
	descripcion			varchar,
	foreign key			( id_especie ) references especies ( id_especie )
);

-- Insertando datos del pokémon
insert into pokemon (nombre, id_especie, altura, peso, descripcion) values
(
	'VENUSAUR', 1, '2,0m', '100,0kg',
	'La flor que tiene en el lomo libera un delicado aroma.
	En combate este aroma tiene un efecto relajante.'
),
(
	'CHARIZARD', 2, '1,7m', '90,5kg',
	'Con las alas que tiene puede alcanzar una altura de casi 1.400m.
	Suele escupir fuego por la boca.'
),
(
	'BLASTOISE', 3, '1,6m', '85,5kg',
	'Para acabar con su enemigo, lo aplasta con el peso de su cuerpo.
	En momentos de apuro, se esconde en el caparazón.'
),
(
	'PIDGEOT', 4, '1,5m', '39,5kg',
	'Para intimidar a su enemigo, extiende las increíbles alas que tiene.
	Este POKéMON vuela a una velocidad increíble.'
),
(
	'GENGAR', 5, '1,5m', '40,5kg',
	'Dicen que sale de la oscuridad para robarle el alma a los que se pierden
	en las montañas.'
),
(
	'JOLTEON', 6, '0,8m', '24,5kg',
	'Si se enfada o asusta, se le eriza el pelaje. Cada pelo se le convierte
	en una afilada púa que hace trizas al rival.'
);

create table tipos_pokemon (
	id_pokemon	integer not null,
	id_tipo		integer not null,
	foreign key (id_pokemon) references pokemon (id_pokemon),
	foreign key (id_tipo) 	 references tipos (id_tipo)
);

insert into tipos_pokemon (id_pokemon, id_tipo) values
( 1, 3  ),	-- VENUSAUR
( 1, 13 ),
( 2, 4  ),	-- CHARIZARD
( 2, 1  ),
( 3, 5  ),	-- BLASTOISE
( 4, 12 ),	-- PIDGEOT
( 4, 1  ),
( 5, 9  ),	-- GENGAR
( 5, 13 ),
( 6, 15 );	-- JOLTEON

-- Creando vista pokedex
create view pokedex as
select pokemon.id_pokemon as num, nombre, tipos.tipo,
especies.especie, pokemon.altura, peso, descripcion
from pokemon
join especies on ( pokemon.id_especie = especies.id_especie )
join tipos_pokemon on ( pokemon.id_pokemon = tipos_pokemon.id_pokemon )
join tipos on ( tipos_pokemon.id_tipo = tipos.id_tipo );
