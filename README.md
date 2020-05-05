# pokedex-sql

Esquema sql de la pokedex

### Como crear la base de datos

```
mkdir test/
sqlite3 test/pokedex.db < pokedex.sql
```

### ¿Cómo acceder a la base de datos?

## Se puede acceder a la base de datos de la siguiente manera:

```
sqlite3 test/pokedex.db
```

### ¿Cómo consultar un pokémon?

## Se puede consultar un pokémon de la siguiente manera:

```
select * from pokedex where nombre = '$pokemon';
```

donde la variable `$pokemon` hace referencia al nombre del **pokémon**, ej: "VENUSAUR"
Pdt: Para consultar un pokémon se debe crear la base de datos y acceder a ella antes de la consulta
