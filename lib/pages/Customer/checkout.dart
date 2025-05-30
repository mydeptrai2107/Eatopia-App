import 'package:eatopia/pages/Customer/user_home.dart';
import 'package:eatopia/services/auth_services.dart';
import 'package:eatopia/services/db.dart';
import 'package:eatopia/services/maps.dart';
import 'package:eatopia/utilities/colours.dart';
import 'package:eatopia/utilities/formatter.dart';
import 'package:eatopia/utilities/order.dart';
import 'package:eatopia/utilities/order_item.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.userData});
  final Map<String, dynamic> userData;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //Information SHowing
              Container(
                padding: const EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin của bạn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 10),
                        const Text(
                          'Địa chỉ',
                          style: TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
                            String? add = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const MapScreen();
                            }));
                            if (add != null) {
                              setState(() {
                                widget.userData['stAddress'] = add;
                              });
                            }
                          },
                          child: Text(
                            'Chỉnh sửa',
                            style: TextStyle(
                              fontSize: 16,
                              color: colorPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.userData['stAddress'],
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    //Phone NUmber Display
                    Row(
                      children: const [
                        Icon(Icons.phone),
                        SizedBox(width: 10),
                        Text(
                          'Số điện thoại',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.userData['phone'] ?? 'Not Provided',
                      style: const TextStyle(
                        fontFamily: 'ubuntu',
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              //Displaying Cart Items or Order Summary
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tóm tắt đơn hàng',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: CartList.list.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.network(
                            CartList.list[index].imageURL,
                            width: 40,
                            height: 40,
                          ),
                          title: Text(
                            CartList.list[index].title,
                            style: const TextStyle(
                                fontFamily: 'ubuntu', fontSize: 15),
                          ),
                          subtitle: Text(
                            Formatter.formatCurrency(
                                CartList.list[index].totalPrice),
                            style: const TextStyle(fontSize: 15),
                          ),
                          trailing: Text(
                            'x${CartList.list[index].quantity}',
                            style: const TextStyle(
                                fontFamily: 'ubuntu', fontSize: 15),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text(
                          'Tổng cộng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          Formatter.formatCurrency(
                            CartList.list.fold(0.0, (p, c) => p + c.totalPrice),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: colorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //Box To Provide Radio List of Payment Methods
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Phương thức thanh toán',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RadioListTile(
                      selected: true,
                      value: 'COD',
                      title: const Text(
                        'Tiền mặt khi giao hàng',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      groupValue: 'COD',
                      onChanged: (value) {
                        setState(() {
                          widget.userData['paymentMethod'] = value;
                        });
                      },
                    ),
                    RadioListTile(
                      selected: true,
                      value: 'COD',
                      title: const Text(
                        'Zalo Pay',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      groupValue: 'Zalo',
                      onChanged: (value) {
                        setState(() {
                          widget.userData['paymentMethod'] = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              //Button To Place Order
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(MediaQuery.of(context).size.width - 30, 50),
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    backgroundColor: colorPrimary),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  Order order = Order(
                    userAddress: widget.userData['stAddress'],
                    payMentMethod: 'COD',
                    phone: widget.userData['phone'],
                    custId: AuthServices().auth.currentUser!.uid,
                    restId: CartList.list[0].restId,
                    status: 'pending',
                    
                  );
                  order.addAllOrderItems(CartList.list);
                  await Db().addOrder(order);
                  setState(() {
                    isLoading = false;
                  });
                  //Show SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: colorPrimary,
                      content: const Text('Đơn hàng đã được đặt thành công'),
                    ),
                  );
                  //Clear Cart
                  CartList.list.clear();
                  //Clear from database
                  await Db().clearCart(AuthServices().auth.currentUser!.uid);
                  //Redirect To Home Screen
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserHomePage(),
                      ),
                      (route) => false);
                },
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 1.2,
                      )
                    : const Text(
                        'Đặt hàng',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
