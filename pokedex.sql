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
('POKéMON de pradera'	 ),
('POKéMON de bosque'	 ),
('POKéMON de agua dulce' ),
('POKéMON de agua salada'),
('POKéMON de caverna'	 ),
('POKéMON de montaña'	 ),
('POKéMON de campo'	  	 ),
('POKéMON de ciudad'	 ),
('POKéMON raros'	  	 );

-- Creando la tabla regiones
create table regiones (
	id_region	integer primary key autoincrement,
	region		varchar
);

-- Insertando datos en la tabla regiones
insert into regiones (region) values
('KANTO'  ),
('JOHTO'  ),
('HOENN'  ),
('SINNOH' ),
('TESELIA'),
('KALOS'  ),
('ALOLA'  ),
('GALAR'  );

-- Creando la tabla tipos
drop table if exists tipos;
create table tipos (
	id_tipo	integer primary key AUTOINCREMENT,
	tipo	varchar
);

-- Insertando los tipos de pokémon
insert into tipos (tipo) values
('VOLADOR.'	 ),
('LUCHA.'	 ),
('PLANTA.'	 ),
('FUEGO.'	 ),
('AGUA.'	 ),
('ROCA.'	 ),
('ACERO.'	 ),
('PSÍQUICO.' ),
('FANTASMA.' ),
('SINIESTRO.'),
('DRAGÓN.'	 ),
('NORMAL.'	 ),
('VENENO.'	 ),
('TIERRA.'	 ),
('ELÉCTRICO.'),
('HIELO.'	 ),
('BICHO.'	 );

-- Creando tabla de especies
drop table if exists especies;
create table especies (
	id_especie	integer primary key AUTOINCREMENT,
	especie		varchar
);

-- Insertando las especies del pokémon
insert into especies (especie) values
('POKéMON SEMILLA'	),
('POKéMON LLAMA'	),
('POKéMON MARISCO'	),
('POKéMON PÁJARO'	),
('POKéMON SOMBRA'	),
('POKéMON RELÁMPAGO');

-- Creando tabla pokemon
drop table if exists pokemon;
create table pokemon (
	id_pokemon			integer primary key AUTOINCREMENT,
	nombre				varchar not null,
	id_especie			integer not null,
	id_habitat			integer not null,
	id_region			integer not null,
	imagen				varchar not null,
	altura				varchar not null,
	peso				varchar not null,
	descripcion			varchar not null,
	foreign key			(id_especie  ) references especies (id_especie ),
	foreign key 		(id_habitat	 ) references habitats (id_habitat ),
	foreign key 		(id_region	 ) references regiones (id_region  ),
	unique				(nombre)
);

create table tipos_pokemon (
	id_pokemon	integer not null,
	id_tipo		integer not null,
	foreign key (id_pokemon) references pokemon (id_pokemon),
	foreign key (id_tipo) 	 references tipos (id_tipo)
);

-- Creando vista pokedex
create view pokedex as
select pokemon.id_pokemon as num, nombre, tipos.tipo,
especies.especie, regiones.region, habitats.habitat, pokemon.altura, peso, descripcion, imagen
from pokemon
join especies 	   on ( pokemon.id_especie 	  = especies.id_especie 	 )
join habitats 	   on ( pokemon.id_habitat 	  = habitats.id_habitat	     )
join regiones 	   on ( pokemon.id_region  	  = regiones.id_region	     )
join tipos_pokemon on ( pokemon.id_pokemon	  = tipos_pokemon.id_pokemon )
join tipos 		   on ( tipos_pokemon.id_tipo = tipos.id_tipo			 );
