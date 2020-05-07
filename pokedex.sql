/**!
 * @package		Pokedex
 * @filename	pokedex.sql
 * @version		1.0
 * @autor		Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 * @contributor	Díaz Urbaneja Víctor Diex Gamar <Sirkennov@outlook.com>
 * @date		04.05.2020 14:44:22 -04
 */

pragma foreign_keys = on;

-- Creando la tabla habitats
create table habitats (
	id_habitat	integer primary key autoincrement,
	habitat		varchar
);

-- Insertando hábitat de el pokémon
insert into habitats (habitat) values
('POKéMON DE PRADERA'),
('POKéMON DE BOSQUE'),
('POKéMON AGUA DULCE'),
('POKéMON AGUA SALADA'),
('POKéMON CAVERNA'),
('POKéMON MONTAÑA'),
('POKéMON CAMPO'),
('POKéMON CIUDAD'),
('POKéMON RAROS');

-- Creando la tabla regiones
create table regiones (
	id_region	integer primary key autoincrement,
	region		varchar
);

-- Insertando datos en la tabla regiones
insert into regiones (region) values
('KANTO'),
('JOHTO'),
('HOENN'),
('SINNOH'),
('TESELIA'),
('KALOS'),
('ALOLA'),
('GALAR');

-- Creando la tabla tipos
drop table if exists tipos;
create table tipos (
	id_tipo	integer primary key AUTOINCREMENT,
	tipo	varchar
);

-- Insertando los tipos de pokémon
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
	nombre				varchar not null,
	id_especie			integer not null,
	id_habitat			integer not null,
	id_region			integer not null,
	altura				varchar not null,
	peso				varchar not null,
	descripcion			varchar not null,
	foreign key			( id_especie ) references especies ( id_especie ),
	foreign key 		(id_habitat	 ) references habitats (id_habitat),
	foreign key 		(id_region	 ) references regiones (id_region)
);

-- Insertando datos del pokémon
insert into pokemon (nombre, id_especie, altura, peso, id_habitat, id_region,  descripcion) values
(
	'VENUSAUR', 1, '2,0m', '100,0kg', 1, 1,
	'La flor que tiene en el lomo libera un delicado aroma.
	En combate este aroma tiene un efecto relajante.'
),
(
	'CHARIZARD', 2, '1,7m', '90,5kg', 2, 1,
	'Con las alas que tiene puede alcanzar una altura de casi 1.400m.
	Suele escupir fuego por la boca.'
),
(
	'BLASTOISE', 3, '1,6m', '85,5kg', 3, 1,
	'Para acabar con su enemigo, lo aplasta con el peso de su cuerpo.
	En momentos de apuro, se esconde en el caparazón.'
),
(
	'PIDGEOT', 4, '1,5m', '39,5kg', 2, 1,
	'Para intimidar a su enemigo, extiende las increíbles alas que tiene.
	Este POKéMON vuela a una velocidad increíble.'
),
(
	'GENGAR', 5, '1,5m', '40,5kg', 5, 1,
	'Dicen que sale de la oscuridad para robarle el alma a los que se pierden
	en las montañas.'
),
(
	'JOLTEON', 6, '0,8m', '24,5kg', 8, 1,
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

-- Creando vista pokédex
create view pokedex as
select pokemon.id_pokemon as num, nombre, tipos.tipo,
especies.especie, pokemon.altura, peso, descripcion
from pokemon
join especies on ( pokemon.id_especie = especies.id_especie )
join tipos_pokemon on ( pokemon.id_pokemon = tipos_pokemon.id_pokemon )
join tipos on ( tipos_pokemon.id_tipo = tipos.id_tipo );
