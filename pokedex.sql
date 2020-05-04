/**!
 * @package   Pokedex
 * @filename  pokedex.sql
 * @version   1.0
 * @autor     Díaz Urbaneja Víctor Eduardo Diex <victor.vector008@gmail.com>
 * @date      04.05.2020 14:44:22 -04
 */

pragma foreign_keys = on;

drop table if exists tipo;
create table tipo (
	id_tipo integer primary key AUTOINCREMENT,
	tipo	varchar
);
