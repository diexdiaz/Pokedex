/**!
 * @package   Pokedex
 * @filename  pokedex.sql
 * @version   1.0
 * @autor     Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 * @date      04.05.2020 14:44:22 -04
 */

pragma foreign_keys = on;

drop table if exists tipos;
create table tipos (
	id_tipo integer primary key AUTOINCREMENT,
	tipo	varchar
);

drop table if exists especies;
create table especies (
	id_especie 	integer primary key AUTOINCREMENT,
	especie		varchar
);

drop table if exists alturas;
create table alturas (
	id_altura 	integer primary key AUTOINCREMENT,
	altura		varchar
);
