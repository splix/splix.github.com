---
layout: bigdoc
title: 'Appengine Groovify'
---

Introduction
==============

About Garfa
-----------

Garfa - is Groovy ActiveRecord for Google Appengine

It's a tiny wrapper around Objectify 3, and should work with any Groovy project for Appengine. It's pretty
 safe to use Garfa in your project, because all underlying work is done by well-tested Objectify, and
 if you have something very specific you could always dig down to Objectify.

Garfa extends you Groovy class with methods for querying, storing and updating models for Appengine database.

Download
--------

### Maven dependency

```xml
<dependency>
    <groupId>com.the6hours</groupId>
    <artifactId>garfa</artifactId>
    <version>0.5-SNAPSHOT</version>
</dependency>
```

```xml
<repositories>
    <repository>
        <id>the6hours-release</id>
        <url>http://maven.the6hours.com/release</url>
        <releases><enabled>true</enabled></releases>
        <snapshots><enabled>false</enabled></snapshots>
    </repository>
</repositories>
```

### Sources

https://github.com/splix/garfa/

License
-------

Project is licensed under Apache 2 license.

How To Use
==============

Initialization code
-------------------

```groovy
ObjectifyFactory objectifyFactory = //... you have to init Objectify before Garfa
Garfa garfa = new Garfa(objectifyFactory)

// Car and Dealer is our models
List<Class> models = [Car, Dealer]

// add magic to our models 
garfa.register(models)
```

Use with Spring Framework
-------------------------

### Init as a bean

If you have a Spring Framework app, you could easily initialize Objectify and Garfa with
your Configuration class (for annotation based configuration). Like:

```groovy
@Configuration
class StorageConfig {

    @Bean
    ObjectifyFactory getObjectifyFactory() {
        ObjectifyFactory objectifyFactory = new ObjectifyFactory()
        Garfa garfa = new Garfa(objectifyFactory)
        def models = [
                Car,
                Dealer
        ]
        models.each { Class clz ->
            objectifyFactory.register(clz) // register with Objectify
            garfa.register(clz) // register with Garfa
        }
        return objectifyFactory
    }
    
}
```

Basic Samples
==============

Models
-------
```groovy

class CarModel {

    @Id
    Long id

    String vendor
    String model
    int year

    void beforeInsert() {
        if year == 0 {
            year = 1896
        }
    }

}

class Car {

    @Id
    Long id
    @Parent
    Key<CarModel> model

    int price
    String color
}
```

Create entities
---------------

```groovy
CarModel mustang = new CarModel(vendor: 'Ford', model: 'Focus', year: 2012)
mustang.save()
Car redMustang = new Car(model: mustang.key, price: 22000, color: 'red')
redMustang.save()
```

Update
------

Make a discount!!! $22000 -> $21000:

```groovy
redMustang.update {
  price = 21000
}
```

Find
----

```groovy
Car blackMustang = Car.findFirstByModelAndColor(mustang.key, 'black')

// load model with ID 5161
CarModel foo = CarModel.load(5161)
```

Load
==============

Get item by ID
--------------

There is two method for loading data from database:

### Model.get(id or key)

Will throw error if there is no entity with specified ID

```groovy
Long id = 1
try {
  Car car = Car.get(id)
} catch (NotFoundException e) {
  ...
}

Key<Car> carKey = new Key<Car>(Car, 1)
try {
  Car car2 = Car.get(carKey)
} catch (NotFoundException e) {
  ...
}
```

### Model.load(id or key)

Will returns `null` if there are no entity with specified ID.

```groovy
Long id = 1
Car car = Car.load(id)
if (car == null) {
   ... not found
}

Key<Car> carKey = new Key<Car>(Car, 1)
Car car2 = Car.load(carKey)
if (car2 == null) {
   ... not found
}
```

### Model.getAll(list of ids or keys)

Loads list of entities for specified ids:

```groovy
List<Car> cars = Car.getAll([1, 2, 3])
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

Find by Ancestor
----------------

```groovy
//a parent instance
CarModel fordFocus

//find by parent:
List<Car> cars = Car.findByAncestor(fordFocus)

//or by a parent key:
List<Car> cars = Car.findByAncestor(fordFocus.key)
```

Save and Update
==============

Create a new data object
------------------------

Use `.save()` method

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

GAE uses optimistic-locking transactions, so, to update an item, Garfa tries to load fresh instance
from DB and execute your code against this instance.

If save of update instance is failed, Garfa retries this steps again, at least 3 times.

### model.update(Closure)

```groovy
car.update { Car loaded ->
  loaded.count++
}
```

### Model.update(id, Closure)

```groovy
Car.update idOrKey, { Car loaded ->
  loaded.count++
}
```

Where:

  * `car` - current instance
  * `idOrKey` - id or Key of instance to update
  * `loaded` - instance loaded for update

Delete
==============


Just use `.delete()` method:

```groovy
Car car = Car.get(15)
car.delete()
```

Dynamic Finders
==============

Garfa supports dynamic finders like:

```groovy
Car.findByModelAndYear("Mustang", 2008)
```

Model.findBy*(...), Model.findBy*(..., options)
-----------------------------------------------

Return list of entries, filtered by specified fields

Options is a optional argument, it's a `Map` with following possible entries:

 * `limit` - max number of elements, like `[limit: 2]`
 * `offset` - initial offset, like `[offset: 10]`
 * `sort` - sort by field value. Value of this option is a field name to use sort for sorting. By default
   it sorts in ascending order, to use descending use `-` as a prefix to field name.
   Like `[sort: 'model`], `[sort: '-year']`
 * `cursor` - string value or `Cursor` instance to use for this query

Model.findFirstBy*(...), Model.findFirstBy(..., options)
--------------------------------------------------------

Same as `findBy`, but returns first element only. Or `null` if not found.

Examples
--------

```groovy
Car car1 = Car.findFirstByVendor('Vaz')
Car cheapFord = Car.findFirstByVendor('Ford', [sort: 'price'])

List<Car> allFords = Car.findByVendor('Ford')
List<Car> firstPageFords = Car.findByVendor('Ford', [limit: 10])
```



Down to Objectify
==============

Query
-----

You have direct access to Objectify's Query, by using two following methods:

 * `.findFirst {}`
 * `.findAll {}`

where you can pass the code that can modify any options of passed Query object. Please notice, that query instance,
it's no a passed parameter, your code will operates directly against query instance, as an DSL.

For example:

```groovy
Car.findAll {
  filter('vendor =', 'Ford')
  limit(10)
}
```

More Objectify
--------------

Use method `.withObjectify {}` of a model, this Closure will be called agains Objectify instance, so you can
do whatever you want:

```groovy
CarModel.withObjectify {
  //all methods here are delegated directly to Objectify instance

  //for example method get(...) going to be like ofy.get(...)
  Driver d = get(Driver, 'john')
}
```

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



