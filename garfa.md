---
layout: bigdoc
title: 'Appengine Groovify'
---

Introduction
==============

Download
--------



License
-------

Project is licensed under Apache 2 license.

How To Use
==============



Basic Samples
==============



Load and Save
==============

Get item by ID
--------------

There is two method for loading data from database:

 * .get(id or key)
 * .load(id or key)
 * .getAll(list of ids or keys)

First will throw error if there is no object with specified ID, second just
returns `null` at this case.

```groovy
Long id = 1
Car car = Car.get(id)

Key<Car> carKey = car.key
Car car2 = Car.get(carKey)

car = Car.load(id) //car can be null if there is no entity with id = 1
```

Query
-----

You have direct access to Objectify's Query, by using two following methods:

 * .findFirst {}
 * .findAll {}

where you can pass the code that can modify any options of passed Query object. Please notice, that query instance,
it's no a passed parameter, your code will operates directly against query instance, as an DSL.

For example:

```groovy
Car.findAll {
  filter('vendor =', 'Ford')
  limit(10)
}
```

Find Where
----------

There is an another method for querying:

```groovy
Clazz.findWhere([<fields>], [<params>]) {
  // code executed against Query
}
```

where:

 * fields - list of field filters, where keys is or simple field names (that mean equality filter), or string
    as fieldname + operator. Like: `[model: 'Ford']` or `['model =': 'Ford']` or `['count >': 5]`. First two are
    equal filters
 * optional query parameters - like `[limit: 4]` or `[order: '-count']`
 * closure - more flexibility when you need something specific. It's your code block that will be executed against
    prepared Query. Like `Car.findWhere([], []) { limit(5) }` (btw, it's the same as `.findWhere([], [limit: 5])`)

For example:

```groovy
//get maximum 20 cars where count > 10, ordered by count field, descending
List cars = Car.findWhere(['count >': 10], [order: '-count', limit: 20])
```

Save and Update
==============

Create new data object
----------------------

Garfa will automaticalyy add .save() method to your domain classes

```groovy
car = new Car(
    brand: 'Ford',
    model: 'Mustang',
    count: 0
)
car.save()
```


Update item in transaction
--------------------------

GAE uses optimistic-locking transactions, so, to update an item, we trying to load it
from DB, and execute your code agains this instance. If save is failed, we retry
load-update-save at least 3 times.

```groovy
car.update { Car loaded ->
  loaded.count++
}
```

where:
  * car - current instance
  * loaded - instance loaded for update (can be different from current)

If saving has been failed - it reloads Car from database, and execute your `.count++`
once again

Dynamic Finders
==============


TO DO

Validation
==============


TO DO

Events
==============

.beforeSave
-----------

Called on both insert and update

```groovy
class Car {
  void beforeSave() {
    ...
  }
}
```

.beforeInsert
-------------

Called before first save (when Id is null)

```groovy
class Car {
  void beforeInsert() {
    ...
  }
}
```


.beforeUpdate
-------------

Called before object update

```groovy
class Car {
  void beforeUpdate() {
    ...
  }
}
```


Links
==============

Project Links
-------------

  * Sources - http://github.com/splix/garfa/
  * Post issue - https://github.com/splix/garfa/issues

Used technologies
-----------------

  * Objectify 3 - http://code.google.com/p/objectify-appengine/
  * Google Appengine - https://developers.google.com/appengine/
  * Groovy - http://groovy.codehaus.org/

Author
------

  * Igor Artamonov - http://igorartamonov.com
  * The 6 Hours - http://the6hours.com



