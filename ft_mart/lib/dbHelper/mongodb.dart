import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import '../constant.dart';
import '../model/box_model.dart';
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
    } catch (e) {}
    return "";
  }

  static Future<Map<String, dynamic>> getData(
      String email, String password) async {
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
        complaintId: data["complaintId"],
        id: data["_id"],
        name: data["name"],
        email: data["email"],
        contact: data["contact"],
        description: data["description"],
        dateTime: data["dateTime"],
        deviceToken: data["deviceToken"],
      ));
    }
    return complaints;
  }

  static Future<void> deleteComplaint(String complaintid) async {
    await db
        .collection('complaints')
        .remove(where.id(ObjectId.parse(complaintid)));
  }

  static Future<void> updateComplaint(
      ObjectId complaintId, bool notified) async {
    db.collection('complaints');
    where.id(complaintId);
  }

  static Future<List<Product>> getProducts() async {
    const int maxRetries = 3;
    int retryCount = 0;
    List<Product> products = [];

    while (retryCount < maxRetries) {
      try {
        final List<Map<String, dynamic>> productsData =
            await productsCollection.find().toList();
        products = productsData.map((data) => Product.fromJson(data)).toList();
        break;
      } catch (error) {
        products = [];
        retryCount++;
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
          .set('discount', product.discount)
          .set('discountedPrice', product.discountedPrice)
          .set('image', product.image),
    );
  }

  static Future<void> insertProduct(Product product) async {
    try {
      await productsCollection.insertOne(product.toJson());
    } catch (e) {}
  }

  static Future<void> deleteProduct(String productId) async {
    final collection = db.collection('products');
    await collection.remove(where.eq('_id', ObjectId.parse(productId)));
  }

  static Future<List<Map<String, dynamic>>> getProductsByCategory(
      String category) async {
    final collection = db.collection('products');

    final products =
        await collection.find(where.eq('category', category)).toList();

    return products;
  }

  static Future<void> addToCart(Product product, double quantity) async {
    try {
      var cartCollection = db.collection('cart');
      await cartCollection.insert(product.toJson());
    } catch (e) {}
  }

  static Future<List<Map<String, Object?>>> searchProducts(String query) async {
    final DbCollection products = db.collection('products');
    final cursor =
        products.find(where.match('name', query, caseInsensitive: true));

    final List<Map<String, Object?>> results = await cursor.toList();

    return results;
  }

  static Future<void> saveOrder(Order order) async {
    await ordersCollection.insert(order.toJson());
  }

  static Future<List<Order>> getOrders() async {
    final List<Map<String, dynamic>> ordersJson =
        await ordersCollection.find().toList();
    final List<Order> orders =
        ordersJson.map((json) => Order.fromJson(json)).toList();
    return orders;
  }

  static Future<void> updateOrderStatus(
      String orderId, String newStatus) async {
    final query = where.eq('orderId', orderId);
    final update = ModifierBuilder().set('status', newStatus);
    await ordersCollection.update(query, update);
  }

  static Future<void> deleteOrder(String orderId) async {
    await ordersCollection.deleteOne(where.eq('orderId', orderId));
  }

  static decreaseStock(String productName) async {
    try {
      await productsCollection.update(
        where.eq('name', productName),
        modify.inc('stock', -1),
      );
    } catch (e) {}
  }

  static getStock(String productName) async {
    try {
      final product =
          await productsCollection.findOne(where.eq('name', productName));
      return product['stock'];
    } catch (e) {}
    return 0;
  }

  static addStock(String productName) {
    try {
      productsCollection.update(
        where.eq('name', productName),
        modify.inc('stock', 1),
      );
    } catch (e) {}
  }

  // Add a discount for a product
  static Future<void> addDiscount(String productId, double discountRate) async {
    await db.collection(productsCollection).update(
          where.eq('_id', ObjectId.fromHexString(productId)),
          modify.set('discount', discountRate),
        );
  }

  // Get the discounted price for a product
  static Future<double> getDiscountedPrice(String productId) async {
    var product = await db.collection(productsCollection).findOne(
          where.eq('_id', ObjectId.fromHexString(productId)),
        );
    if (product != null && product['discount'] != null) {
      double price = product['price'] as double;
      double discountRate = product['discount'] as double;
      double discountedPrice = price * (1 - discountRate);
      return discountedPrice;
    } else {
      // Return the original price if no discount is set
      return (product['price'] as double);
    }
  }

  // Remove the discount for a product
  static Future<void> removeDiscount(String productId) async {
    await db.collection(productsCollection).update(
          where.eq('_id', ObjectId.fromHexString(productId)),
          modify.unset('discount'),
        );
  }

  static Future<List<CustomizationOption>> getCustomizationOptions() async {
    final collection = db.collection('customization');
    final List<Map<String, dynamic>> jsonOptions =
        await collection.find().toList();
    return jsonOptions
        .map((json) => CustomizationOption.fromJson(json))
        .toList();
  }
}
