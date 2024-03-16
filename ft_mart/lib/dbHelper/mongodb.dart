import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../constant.dart';
import '../model/complaints_model.dart';
import '../model/customer_model.dart';
import '../model/orders_model.dart';
import '../model/product_model.dart';

class MongoDatabase {
  static var db,
      userCollection,
      complainCollection,
      productsCollection,
      cartCollection,
      ordersCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    inspect(db);
    userCollection = db.collection('customers');
    complainCollection = db.collection('complaints');
    productsCollection = db.collection('products');
    cartCollection = db.collection('cart');
    ordersCollection = db.collection('orders');
  }

  static Future<bool> validateSecurityAnswer(
      String email, String contact) async {
    try {
      final result = await userCollection.findOne(
        where.eq('email', email).eq('contact', contact.trim()),
      );

      return result != null;
    } catch (e) {
      print("Error in validateSecurityAnswer: $e");
      return false;
    }
  }

  static Future<void> changePassword(String email, String newPassword) async {
    await userCollection.update(
        where.eq('email', email), modify.set('password', newPassword));
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

  static Future<Map<String, dynamic>> getData(
      String email, String password) async {
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
        id: data["_id"],
        name: data["name"],
        email: data["email"],
        contact: data["contact"],
        description: data["description"],
      ));
    }
    return complaints;
  }

  static Future<void> deleteComplaint(String complaintid) async {
    print('Deleting complaint with ID: $complaintid');
    await db
        .collection('complaints')
        .remove(where.id(ObjectId.parse(complaintid)));
    print('Complaint deleted successfully.');
  }

  static Future<List<Product>> getProducts() async {
    final int maxRetries = 3;
    int retryCount = 0;
    List<Product> products = [];

    while (retryCount < maxRetries) {
      try {
        final List<Map<String, dynamic>> productsData =
            await productsCollection.find().toList();
        products = productsData.map((data) => Product.fromJson(data)).toList();
        // If database connection and data fetching succeed, break out of the loop
        break;
      } catch (error) {
        // If an error occurs, print the error message and retry after a delay
        print("Error fetching products: $error");
        products = [];
        retryCount++;
        // Wait for a short delay before retrying
        await Future.delayed(const Duration(seconds: 2));
      }
    }
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
  }

  static Future<void> addToCart(Product product, double quantity) async {
    try {
      var cartCollection = db.collection('cart');
      await cartCollection.insert(product.toJson());
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  static Future<List<Map<String, Object?>>> searchProducts(String query) async {
    final DbCollection products = db.collection('products');
    final cursor =
        await products.find(where.match('name', query, caseInsensitive: true));

    final List<Map<String, Object?>> results = await cursor.toList();

    return results;
  }

  static Future<void> saveOrder(Order order) async {
    await ordersCollection.insert(order.toJson());
  }

  static Future<List<Order>> getOrders() async {
    final List<Map<String, dynamic>> ordersJson = await ordersCollection.find().toList();
    final List<Order> orders = ordersJson.map((json) => Order.fromJson(json)).toList();
    print('Fetched orders: $orders');
    return orders;
  }

  static decreaseStock(String productName) async {
    print("stock depleted in mongodb");
    await productsCollection.update(
      where.eq('name', productName),
      modify.inc('stock', -1),
    );
  }

  static getStock(String productName) async {
    final product = await productsCollection.findOne(where.eq('name', productName));
    return product['stock'];
  }

}
