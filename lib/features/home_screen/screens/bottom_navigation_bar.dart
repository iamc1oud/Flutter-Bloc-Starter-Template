import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeko_hotel_crm/features/analytics/screens/analytics_screens.dart';
import 'package:zeko_hotel_crm/features/home_screen/screens/home_page_drawer.dart';
import 'package:zeko_hotel_crm/features/order_management/screens/order_management_screens.dart';
import 'package:zeko_hotel_crm/main.dart';
import 'package:zeko_hotel_crm/utils/extensions/extensions.dart';

import '../../auth/logic/cubit/auth_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentPage = 0;

  @override
  void initState() {
    context.read<AuthCubit>().getHotelDetails();

    // Foreground notification
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        logger.d(
            'Message also contained a notification: ${message.notification?.toMap()}');
      }
    });
    super.initState();
  }

  final tabs = [
    const AnalyticsTabView(),
    const OrderManagementTabView(),
    const AppDrawer()
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${authState.hotelDetails?.detail?.hotelName}',
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: Badge.count(
                      count: 0, child: const Icon(Icons.fastfood_outlined))),
              Spacing.wlg
            ],
          ),
          body: tabs.elementAt(_currentPage),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentPage,
              onTap: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.analytics_outlined), label: 'Analytics'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.food_bank_outlined), label: 'Orders'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.grid_3x3), label: 'More')
              ]),
        );
      },
    );
  }
}
