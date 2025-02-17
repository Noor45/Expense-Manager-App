import 'package:expense_wallet/utils/colors.dart';
import 'package:flutter/material.dart';

class CompanyMainScreen extends StatelessWidget {
  static const String ID = "company_main_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorRefer.kPrimaryColor,
        centerTitle: true,
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: [
            DashboardCard(
              title: 'General Expenses List',
              count: 14,
              icon: Icons.camera_alt,
            ),
            DashboardCard(
              title: 'Business Expense List',
              count: 16,
              icon: Icons.camera_alt,
            ),
            DashboardCard(
              title: 'Departments',
              count: 7,
              icon: Icons.apartment,
            ),
            DashboardCard(
              title: 'Department Purchasing List',
              count: 5,
              icon: Icons.shopping_cart,
            ),
            DashboardCard(
              title: 'Employees List',
              count: 7,
              icon: Icons.people,
            ),
            DashboardCard(
              title: 'Banks',
              count: 5,
              icon: Icons.account_balance,
            ),
            DashboardCard(
              title: 'Everyday Expenses List',
              count: 8,
              icon: Icons.camera_alt,
            ),
            DashboardCard(
              title: 'Users',
              count: 6,
              icon: Icons.person,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserListScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final VoidCallback? onTap;

  DashboardCard({
    required this.title,
    required this.count,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                child: Icon(icon, color: Colors.white),
                backgroundColor: Colors.blue,
              ),
              SizedBox(height: 8.0),
              Text(title, textAlign: TextAlign.center),
              SizedBox(height: 8.0),
              Text('$count', style: TextStyle(fontSize: 24)),
            ],
          ),
        ),
      ),
    );
  }
}

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final users = [
      User('John Doe', 'john.doe@example.com', 'Full Access', Colors.green),
      User('Jane Smith', 'jane.smith@example.com', 'Moderate Access', Colors.orange),
      User('Mike Johnson', 'mike.johnson@example.com', 'Limited Access', Colors.red),
      // Add more users as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: users.length,
        itemBuilder: (context, index) {
          return UserCard(user: users[index]);
        },
      ),
    );
  }
}

class User {
  final String name;
  final String email;
  final String access;
  final Color accessColor;

  User(this.name, this.email, this.access, this.accessColor);
}

class UserCard extends StatelessWidget {
  final User user;

  UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(user.name[0]),
          backgroundColor: user.accessColor,
        ),
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            Text(
              user.access,
              style: TextStyle(color: user.accessColor),
            ),
          ],
        ),
      ),
    );
  }
}
