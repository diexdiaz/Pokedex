# pokedex-sql

Esquema sql de la pokedex

### ¿Cómo crear la base de datos?

#### Para crear la base de datos se debe hacer lo siguiente:

```
mkdir test/
sqlite3 test/pokedex.db < pokedex.sql
```

### ¿Cómo acceder a la base de datos?

#### Para acceder la base de datos se debe hacer lo siguiente:

```
sqlite3 test/pokedex.db
```

### ¿Cómo consultar un pokémon?

#### Para consultar un pokémon en la base de datos se debe hacer lo siguiente:

```
select * from pokedex where nombre = '$pokemon';
```

donde la variable `$pokemon` hace referencia al nombre del **pokémon**, ej: "VENUSAUR"

Pdt: Para consultar un pokémon se debe crear la base de datos y acceder a ella antes de la consulta
