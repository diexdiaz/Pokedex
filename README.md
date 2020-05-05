# pokedex-sql

Esquema sql de la pokedex

### Como crear la base de datos

```
mkdir test/
sqlite3 test/pokedex.db < pokedex.sql
```

### Como consultar un pokémon

```
select pokemon.id_pokemon, nombre, tipos.tipo,
especies.especie, pokemon.altura, peso, descripcion
from pokemon
join especies on ( pokemon.id_especie = especies.id_especie )
join tipos_pokemon on ( pokemon.id_pokemon = tipos_pokemon.id_pokemon )
join tipos on ( tipos_pokemon.id_tipo = tipos.id_tipo )
where pokemon.nombre = "$pokemon";
```

donde la variable `$pokemon` hace referencia al nombre del **pokémon**, ej: "VENUSAUR"
