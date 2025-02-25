import 'package:flutter/material.dart';
import '../controller/user_controller.dart';
import '../routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController _userController = UserController();
  String _userName = '';
  double _balance = 0.0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    var userData = await _userController.getUserProfile();
    setState(() {
      _userName = userData['name'] ?? '';
      _balance = userData['balance'] ?? 0.0;
    });
  }

  Widget _buildQuickActionCard(Widget imageOrIcon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Icon(icon, size: 32, color: Colors.blue[600]),
              FractionallySizedBox(
                widthFactor: 1.0, // 80% of the card's width
                child: imageOrIcon,
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFc4dafa),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'CashBank',
          style: TextStyle(
          color: Colors.grey[800],
          fontWeight: FontWeight.bold,
        ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.grey[600]),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.grey[200],
                              child: Icon(Icons.person, size: 32, color: Colors.grey[600]),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _userName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                Text(
                                  'Saldo Disponible',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          '\$${_balance.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildQuickActionCard(
                      Image.asset('assets/pagos.png', width: 200, height: 200),
                      'Pagos',
                          () => Navigator.pushNamed(context, AppRoutes.pagos),
                    ),
                    _buildQuickActionCard(
                      Image.asset('assets/historial.png', width: 200, height: 200),
                      'Historial',
                          () => Navigator.pushNamed(context, AppRoutes.transacciones),
                    ),
                    _buildQuickActionCard(
                      Image.asset('assets/tarjetas.png', width: 200, height: 200),
                      'Tarjetas',
                          () => Navigator.pushNamed(context, AppRoutes.tarjetas),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey[600],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
            // Ya estamos en la pantalla de inicio
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.transacciones);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.pagos);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.tarjetas);
              break;
            case 4:
              Navigator.pushReplacementNamed(context, AppRoutes.login);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Pagos'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Tarjetas'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Salir'),
        ],
      ),
    );
  }
}