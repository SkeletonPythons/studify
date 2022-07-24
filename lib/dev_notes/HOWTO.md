# How to access Firebase Firestore

This guide will help you to develop a model and methods to access Firebase Firestore.

## What to do first

First you need to create a model of whatever it is you want to save to the Firestore.

> A model is just a class that represents a object. It can have properties and methods, but we're only interested in properties for this

### Model example and explaination

  The following is an example of a model class called `Vehicle`. It has three properties, `name` and `year` and `color`. Generally, you'll want to use native types because it will be easier to work with.

```dart
class VehicleModel {
    final String name;
    final int year;
    final String color;
}
```

Next we will add a constructor to the model. This constructor will be the one that will be used to create a new instance of the model locally and will be populated with data from user input.

```dart
VehicleModel(this.name, this.year, this.color);
```

You can make properties optional by adding `?` to the end of the type. You can set defaults for the properties or make them required. Here's everything so far.

> Personally, I like to add an `id` property of type String and have it automatically initialized in the constructor with `DateTime.now().millisecondsSinceEpoch.toString()`

```dart
class VehicleModel {
    final String name;
    final String id;
    final int year;
    final String? color; // This is an optional property 

    VehicleModel({
        required this.name, 
        required this.year, 
        this.color = 'Black' // This is an optional property with a default value,
        }) : id = DateTime.now().millisecondsSinceEpoch.toString();
}
```

Next we will add a method to the model that takes all the properties and turns them into a Map. This is a map that has a key of type `String` and a value of type `dynamic`. This formats the data for Firebase.

> It is **VERY** important that no typos are made in the keys of the map. Also the key MUST match the name of the corresponding field in Firebase.

```dart
//....
Map<String, dynamic> toMap() {
    return {
        'name': name,
        'year': year,
        'color': color,
    };
}
```

Now we need to make another constructor that will take data received from Firebase and returns a `VehicleModel` for our app to use

```dart
// ...
VehicleModel.fromMap(Map<String,dynamic>map):
    this.name = map['name'],
    this.year = map['year'],
    this.color = map['color'] ?? 'black', // this is optional so we need to be able to handle it if it's null we use `??` for that
    this.id = map['id'];
```

And with that our model is complete. Here's all of it together.

```dart
class VehicleModel {
    final String name;
    final String id;
    final int year;
    final String? color; // This is an optional property 

    VehicleModel({
        required this.name, 
        required this.year, 
        this.color = 'Black'
        }) : id = DateTime.now().millisecondsSinceEpoch.toString();
    
    VehicleModel.fromMap(Map<String,dynamic>map) :
    this.name = map['name'],
    this.year = map['year'],
    this.color = map['color'] ?? 'black',
    this.id = map['id'];

    Map<String, dynamic> toMap() {
    return {
        'name': name,
        'year': year,
        'color': color,
    };
}
```

## DB methods

Now that we have our model we can use it to interface with Firebase. Here's some things to know about how things are stored.

- Firestore is stored basically in json format.
- The Firestore is made up of collections and documents and fields. collections contain documents and documents contain fields
- documents can also contain other collections to nest our data.

> Just a note here. This is a very simple implementation of the database that can be used to make our app work. It is probably much more complicated than this.

When accessing the database we have to understand that it takes time to get the data from the internet, so we will be working with Futures in  Dart. Here is a method that will take a `VehicleModel` and save it to a collection for the user.

```dart
//... in the DB class

Future<void> saveVehicle(VehicleModel vehicle) async {
    try {
        await FirebaseFirestore
        .instance
        .collection('users')
        .doc('Auth.instance.USER.uid')
        .collection('vehicles')
        .doc(vehicle.id)
        .set(vehicle.toMap());
        } catch (e) {
            debugPrint(e.toString());
        }
    }
}
```

### Some things about the above code

- **async** - This keyword is used to make the function asynchronously.
- **await** - This tells the function not to continue until this section is complete.
- **try** - This is a way to handle exceptions. It must be followed by a `catch` or `finally` block.
- **catch** - This section will complete if the `try` block has an error.
- **`.set`** - This is used to create a new document. If the document already exists calling this will replace the old document.
- Document ids must be unique for the collection they are in. If you do not set one yourself, firebase will create one for you. We use `DateTime.now().millisecondsSinceEpoch.toString()` to create our own id and ensure that it is unique

## More Examples

```dart

Future<VehicleModel> getFromDB(String docID) async {
    try{
        await FirebaseFirestore
        .instance
        .collection('users')
        .doc(Auth.instance.USER.uid)
        .collection('vehicles')
        .doc(docID)
        .get()
        .then((DocumentRefrence ref) {
            if (ref.exists) {
                return VehicleModel.fromMap(ref.data())
            }
        })
    } catch (e) {
        debugPrint(e.toString());
    }
}

Future<void> updateVehicle(VehicleModel vehicle) async {
    try {
        await FirebaseFirestore
        .instance
//        .collection('users')
//        .doc('Auth.instance.USER.uid')
//        .collection('vehicles')
//        .doc(vehicle.id)
        .doc('users/${Auth.instance.USER.uid}/vehicles/${vehicle.id}') // This line of code gets the same document as the four lines above commented out above.
        .update(vehicle.toMap());
        } catch (e) {
            debugPrint(e.toString());
        }
    }
}

```

I hope this helps clear things up and makes it easy to interface with firestore. Let me know if you have any questions.