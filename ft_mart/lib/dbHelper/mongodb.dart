import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import '../constant.dart';
import '../model/cart_model.dart';
import '../model/complaints_model.dart';
import '../model/customer_model.dart';
import '../model/product_model.dart';

class MongoDatabase {
  static var db, userCollection, complainCollection, productsCollection,
      cartCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection('customers');
    complainCollection = db.collection('complaints');
    productsCollection = db.collection('products');
    cartCollection = db.collection('cart');
  }

  static Future<String> insert(CustomerModel customer) async {
    try {
      var result = await userCollection.insertOne(customer.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something wrong while adding data";
      }
    } catch (e) {
      print(e.toString());
    }
    return "";
  }

  static Future<Map<String, dynamic>> getData(String email,
      String password) async {
    print("getdata() called in mongodb");
    final arrData = await userCollection.findOne({"email": email});
    // print(arrData);
    if (arrData != null) {
      if (arrData["password"] == password) {
        return arrData;
      } else {
        return {"error": "Invalid username or password"};
      }
    }
    return {"error": "Invalid username or password"};
  }

  static Future<String> saveComplaint(Complaint complaint) async {
    var result = await complainCollection.insertOne(complaint.toJson());
    if (result.isSuccess) {
      return "Complaint submitted";
    } else {
      return "Something wrong while adding data";
    }
  }

  static Future<List<Complaint>> getComplaints() async {
    List<Map<String, dynamic>> dataList =
    await complainCollection.find().toList();
    List<Complaint> complaints = [];
    for (var data in dataList) {
      complaints.add(Complaint(
        name: data["name"],
        email: data["email"],
        contact: data["contact"],
        description: data["description"],
      ));
    }
    return complaints;
  }

  static Future<List<Product>> getProducts() async {
    final List<Map<String, dynamic>> productsData =
    await productsCollection.find().toList();
    final List<Product> products =
    productsData.map((data) => Product.fromJson(data)).toList();
    print(products.first.id);
    return products;
  }

  static Future<void> updateProduct(Product product) async {
    await productsCollection.update(
      where.eq('_id', product.id),
      modify
          .set('name', product.name)
          .set('price', product.price)
          .set('stock', product.stock)
          .set('category', product.category)
          .set('image', product.image),
    );
  }

  static Future<void> insertProduct(Product product) async {
    try {
      await productsCollection.insertOne(product.toJson());
    } catch (e) {
      print('Error inserting product: $e');
    }
  }

  static Future<void> deleteProduct(String productId) async {
    final collection = db.collection('products');
    await collection.remove(where.eq('_id', ObjectId.parse(productId)));
    //await _fetchProducts(); // Refresh the product list after deletion
  }

  static Future<void> addToCart(Product product, double quantity) async {
    try {
      var cartCollection = db.collection('cart');
      await cartCollection.insert(product.toJson());
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }
}
