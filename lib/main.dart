import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(JewelryApp());
}
class Product {
  final String id;
  final String name;
  final int price;
  final String image;
  final String category;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.category,
  });
}

final List<Product> allProducts = [
  Product(id: 'p1', name: 'Gold Necklace', price: 25000, image: 'assets/images/necklace.jpg', category: 'Gold'),
  Product(id: 'p2', name: 'Diamond Ring', price: 55000, image: 'assets/images/ring.jpg', category: 'Diamond'),
  Product(id: 'p3', name: 'Diamond Earrings', price: 12000, image: 'assets/images/earrings.jpg', category: 'Diamond'),
  Product(id: 'p4', name: 'Gold Chain', price: 25000, image: 'assets/images/chain.jpg', category: 'Gold'),
  Product(id: 'p5', name: 'Gold Bracelet', price: 15000, image: 'assets/images/braclet.jpg', category: 'Gold'),
  Product(id: 'p6', name: 'Gold Ring', price: 15000, image: 'assets/images/gold ring.jpg', category: 'Gold'),
  Product(id: 'p7', name: 'Gold Earrings', price: 25000, image: 'assets/images/goldearrings.jpg', category: 'Gold'),
  Product(id: 'p8', name: 'Diamond Necklace', price: 65000, image: 'assets/images/diomand necklece.jpg', category: 'Diamond'),
  Product(id: 'p9', name: 'Diamond Bracelet', price: 55000, image: 'assets/images/d braclet.webp', category: 'Diamond'),
  Product(id: 'p10', name: 'Gold Anklet', price: 25000, image: 'assets/images/anklet.webp', category: 'Gold'),
];

final ValueNotifier<List<Product>> cartNotifier = ValueNotifier<List<Product>>([]);
final ValueNotifier<List<Product>> wishlistNotifier = ValueNotifier<List<Product>>([]);
class JewelryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jewelry Store',
      theme: ThemeData(primarySwatch: Colors.pink),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Icon(Icons.diamond, color: Colors.pinkAccent, size: 88),
          SizedBox(height: 10),
          Text('Jewelry Store', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.pink)),
          SizedBox(height: 14),

          CircularProgressIndicator(color: Colors.pink),
        ]),
      ),
    );
  }
}


class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});


  Future<void> login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainApp()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),


          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            onPressed: () => login(context),
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SignupScreen()),
            ),


            child: const Text("Don't have an account? Sign Up"),
          ),
        ]),
      ),
    );
  }
}



class SignupScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  SignupScreen({super.key});

  Future<void> signup(BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainApp()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(


            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),



          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            onPressed: () => signup(context),
            child: const Text('Sign Up', style: TextStyle(color: Colors.white54)),
          ),
        ]),
      ),
    );
  }
}




class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}


class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;



  final List<Widget> _pages = [
    HomeScreen(),
    FavoritesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // listen to notifiers to rebuild bottom bar (badge)
    cartNotifier.addListener(() { setState(() {}); });
    wishlistNotifier.addListener(() { setState(() {}); });
  }


  @override
  void dispose() {
    cartNotifier.removeListener(() {});
    wishlistNotifier.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,




        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Stack(children: [
              const Icon(Icons.favorite),
              if (wishlistNotifier.value.isNotEmpty)
                Positioned(right: 0, top: 0, child: _badge(wishlistNotifier.value.length)),
            ]),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Stack(children: [
              const Icon(Icons.shopping_cart),
              if (cartNotifier.value.isNotEmpty)


                Positioned(right: 0, top: 0, child: _badge(cartNotifier.value.length)),
            ]),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  static Widget _badge(int count) {
    return CircleAvatar(radius: 8, backgroundColor: Colors.white, child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.pink)));
  }
}



class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'All';

  List<Product> get filteredProducts {
    if (selectedCategory == 'All') {
      return allProducts;
    } else {
      return allProducts
          .where((p) => p.category == selectedCategory)
          .toList();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jewelry Store'), centerTitle: true),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _categoryButton('All'),
                _categoryButton('Gold'),
                _categoryButton('Diamond'),
              ],
            ),
          ),



          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return _productCard(product, context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _categoryButton(String title) {
    final bool isSelected = selectedCategory == title;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.pink : Colors.grey.shade300,
        foregroundColor: isSelected ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),


      onPressed: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Text(title),
    );
  }


  Widget _productCard(Product product, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.asset(product.image, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(


                  'Rs ${product.price}',
                  style: const TextStyle(
                      color: Colors.pink, fontWeight: FontWeight.w600),
                ),

                /// ❤️ + 🛒 ROW (RESTORED)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    ValueListenableBuilder<List<Product>>(
                      valueListenable: wishlistNotifier,
                      builder: (_, list, __) {
                        final isFav =
                        list.any((x) => x.id == product.id);
                        return IconButton(
                          icon: Icon(
                            isFav
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                            isFav ? Colors.pink : Colors.grey,
                          ),
                          onPressed: () {


                            if (isFav) {
                              wishlistNotifier.value =
                              List<Product>.from(
                                  wishlistNotifier.value)
                                ..removeWhere(
                                        (x) => x.id == product.id);
                            } else {
                              wishlistNotifier.value =
                              List<Product>.from(
                                  wishlistNotifier.value)
                                ..add(product);
                            }
                          },

                        );
                      },
                    ),



                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart,
                          color: Colors.pink),
                      onPressed: () {
                        cartNotifier.value =
                        List<Product>.from(cartNotifier.value)
                          ..add(product);



                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${product.name} added to cart'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],


      ),
    );
  }
}



class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});
  @override



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites'), centerTitle: true),
      body: ValueListenableBuilder<List<Product>>(
        valueListenable: wishlistNotifier,
        builder: (_, list, __) {
          if (list.isEmpty) {
            return const Center(child: Text('No favorites yet!'));
          }
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return ListTile(
                leading: Image.asset(item.image, width: 60, fit: BoxFit.cover),
                title: Text(item.name),
                subtitle: Text('Rs ${item.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.pink),
                  onPressed: () {
                    wishlistNotifier.value = List<Product>.from(wishlistNotifier.value)..removeWhere((x) => x.id == item.id);
                    // also un-favorite visually in home (listens to notifier)
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} removed from favorites')));
                  },


                ),
              );
            },
          );
        },
      ),
    );
  }
}
class CartScreen extends StatelessWidget {
  CartScreen({super.key});



  double _subtotal(List<Product> items) => items.fold(0, (s, p) => s + p.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart'), centerTitle: true),
      body: ValueListenableBuilder<List<Product>>(
        valueListenable: cartNotifier,
        builder: (_, cart, __) {
          if (cart.isEmpty) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                Icon(Icons.shopping_bag, size: 80, color: Colors.pink),
                SizedBox(height: 12),
                Text('Your cart is empty!', style: TextStyle(fontSize: 18)),
              ]),
            );
          }

          final subtotal = _subtotal(cart);
          return Column(children: [
            Expanded(
              child: ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final item = cart[index];
                  return ListTile(
                    leading: Image.asset(item.image, width: 60, fit: BoxFit.cover),
                    title: Text(item.name),
                    subtitle: Text('Rs ${item.price}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.pink),
                      onPressed: () {
                        cartNotifier.value = List<Product>.from(cartNotifier.value)..removeAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} removed from cart')));
                      },
                    ),
                  );
                },
              ),
            ),




            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: const BorderRadius.vertical(top: Radius.circular(18))),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal:'), Text('Rs $subtotal')]),
                const SizedBox(height: 6),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Items:'), Text('${cart.length}')]),
                const Divider(height: 18, thickness: 1.1),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40)),
                  onPressed: () {
                    // navigate to checkout and pass snapshot of cart and subtotal
                    Navigator.push(






                      context,
                      MaterialPageRoute(
                        builder: (_) => AddressScreen(
                          items: List<Product>.from(cart),
                        ),
                      ),
                    );

                  },
                  child: const Text('Proceed to Checkout', style: TextStyle(color: Colors.white)),
                ),
              ]),
            )
          ]);
        },
      ),
    );
  }





}
class AddressScreen extends StatefulWidget {
  final List<Product> items;

  AddressScreen({required this.items, super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}




class _AddressScreenState extends State<AddressScreen> {
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Details')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(







          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text('Address',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(
              controller: addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter your full address',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            const Text('Phone Number',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            TextField(





              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '03XXXXXXXXX',
                border: OutlineInputBorder(),
              ),
            ),






            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 40),
                ),
                onPressed: () {
                  if (addressController.text.isEmpty ||
                      phoneController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                          Text('Please fill all fields')),
                    );
                    return;
                  }




                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutScreen(
                        items: widget.items,
                      ),
                    ),
                  );
                },






                child: const Text('Confirm Address',
                    style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CheckoutScreen extends StatelessWidget {
  final List<Product> items;
  CheckoutScreen({required this.items, super.key});

  double get subtotal => items.fold(0.0, (s, p) => s + p.price);
  double get shipping => items.isEmpty ? 0.0 : 500.0;
  double get grandTotal => subtotal + shipping;





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout Summary')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Order Summary', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pink)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) {
                final p = items[i];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: Image.asset(p.image, width: 56, fit: BoxFit.cover),
                    title: Text(p.name),
                    trailing: Text('Rs ${p.price}'),
                  ),
                );
              },






            ),
          ),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Subtotal:'), Text('Rs ${subtotal.toStringAsFixed(0)}')]),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Shipping:'), Text('Rs ${shipping.toStringAsFixed(0)}')]),
          const Divider(height: 20, thickness: 1.2),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Grand Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Rs ${grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.pink)),
          ]),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: const Text('Confirm Order'),


              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28)),
              onPressed: () {
                // clear cart global notifier
                cartNotifier.value = [];
                showDialog(
                  context: context,


                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    title: const Text(' Order Placed!'),
                    content: Text('Thank you — your order of Rs ${grandTotal.toStringAsFixed(0)} is placed.'),
                    actions: [
                      TextButton(

                        onPressed: () {
                          cartNotifier.value = [];

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => MainApp()),
                                (route) => false,
                          );
                        },
                        child: const Text('OK', style: TextStyle(color: Colors.pink)),
                      )

                    ],
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});


  @override
  Widget build(BuildContext context) {


    final user = FirebaseAuth.instance.currentUser; // get current user

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: Center(


        child: Column(



          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
                radius: 44,
                backgroundColor: Colors.pinkAccent,


                child: Icon(Icons.person, size: 44, color: Colors.white)),
            const SizedBox(height: 12),
            const Text('Welcome!', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 6),
            Text(



              user?.email ?? 'No Email',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(




              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,


                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 28)),
              onPressed: () async {



                await FirebaseAuth.instance.signOut();
                cartNotifier.value = [];

                wishlistNotifier.value = [];


                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                );
              },


            )
          ],
        ),
      ),
    );
  }
}