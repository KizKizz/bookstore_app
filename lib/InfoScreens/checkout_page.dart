import 'dart:convert';

import 'package:bookstore_project/Data/book_data_handler.dart';
import 'package:bookstore_project/Data/order_data_handler.dart';
import 'package:bookstore_project/Data/sales_record_data_handler.dart';
import 'package:bookstore_project/InfoScreens/book_list.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../Data/customer_data_handler.dart';
import '../Data/employee_data_handler.dart';
import '../state_provider.dart';

List<String> _employeesDropDownVal = [];
String? _curEmployeeChoice;
int _customerInfoIndex = 0;
int _shippingAddressIndex = 0;
int orderNumber = 0;
String curPaymentMethod = '';

double subTotal = 0.0;
double shippingCost = 0.0;
double subTotalTax = 0.0;
double totalCost = 0.0;

List<TextEditingController> priceControllers = [];
List<TextEditingController> existingCustomerInfoControllers = [];
List<String> checkoutPrices = [];
Customer curOrderingCustomer =
    Customer('', '', '', '', '', '', '', '', '', '', '', '', '');
Employee curSalesperson = Employee(
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
  '',
);

final List<String> _orderStatusList = [
  'Picked Up',
  'Customer Will Pickup',
  'To Be shipped',
  'Shipped'
];
String _orderStatus = _orderStatusList[0];

enum ShippingOptions { inPerson, inStore, nextDay, express, standard }

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final MultiSplitViewController _checkoutMvController =
      MultiSplitViewController(weights: [0.65]);

  double _shippingInfoHeight = 330;
  double _customerInfoHeight = 360;
  ShippingOptions? _curShippingOption = ShippingOptions.inPerson;
  final _searchCustomerController = TextEditingController();
  List<Customer> _searchCustomerList = [];
  FocusNode searchFieldFocusNode = FocusNode();

  late DateTime now;
  late String _orderDate = '';
  String _deliveryDate = '';

  @override
  void initState() {
    super.initState();

    now = DateTime.now();
    _orderDate = DateFormat('MM-dd-yyyy HH:mm').format(now);
    _deliveryDate = DateFormat('MM-dd-yyyy HH:mm').format(now);

    //Get prices to a separated list
    if (checkoutPrices.isEmpty) {
      checkoutPrices = List.filled(checkoutCartList.length, '');
      checkoutPrices = List.generate(checkoutCartList.length,
          (i) => checkoutPrices[i] = checkoutCartList[i].retailPrice);
      for (var price in checkoutPrices) {
        subTotal += double.parse(price);
      }
    } else if (checkoutPrices.isNotEmpty &&
        checkoutPrices.length < checkoutCartList.length) {
      for (int i = checkoutPrices.length; i < checkoutCartList.length; i++) {
        checkoutPrices.add(checkoutCartList[i].retailPrice);
        subTotal += double.parse(checkoutPrices[i]);
      }
    } else if (checkoutPrices.isNotEmpty &&
        checkoutPrices.length > checkoutCartList.length) {
      subTotal -= double.parse(checkoutPrices[checkoutDropDownRemoveIndex]);
      checkoutPrices.removeAt(checkoutDropDownRemoveIndex);
      priceControllers.removeAt(checkoutDropDownRemoveIndex);
    }

    //Text controllers
    priceControllers = List.generate(checkoutCartList.length,
        (i) => TextEditingController()..text = checkoutPrices[i]);
    existingCustomerInfoControllers =
        List.generate(11, (i) => TextEditingController());
  }

  @override
  void dispose() {
    priceControllers.forEach((c) => c.dispose());
    existingCustomerInfoControllers.forEach((e) => e.dispose());
    super.dispose();
  }

  String _getFullAddress(Customer curCustomer) {
    String temp = '';
    if (curCustomer.suiteNum.isEmpty) {
      temp =
          '${curCustomer.streetAddress} ${curCustomer.city} ${curCustomer.state} ${curCustomer.zipCode}';
    } else {
      temp =
          '${curCustomer.streetAddress} ${curCustomer.suiteNum} ${curCustomer.city} ${curCustomer.state} ${curCustomer.zipCode}';
    }
    return temp;
  }

  //Search bar Handler
  @override
  Widget _searchField() {
    return TextField(
        focusNode: searchFieldFocusNode,
        controller: _searchCustomerController,
        onChanged: (String text) {
          setState(() {
            _searchCustomerList = [];
            Iterable<Customer> _foundCustomer = [];
            _foundCustomer = mainCustomerListCopy.where((element) =>
                element.firstName.toLowerCase().contains(text.toLowerCase()) ||
                element.lastName.toLowerCase().contains(text.toLowerCase()) ||
                element.id.toLowerCase().contains(text.toLowerCase()) ||
                element.streetAddress
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.suiteNum.toLowerCase().contains(text.toLowerCase()) ||
                element.city.toLowerCase().contains(text.toLowerCase()) ||
                element.state.toLowerCase().contains(text.toLowerCase()) ||
                element.zipCode.toLowerCase().contains(text.toLowerCase()) ||
                element.phoneNumber
                    .toLowerCase()
                    .contains(text.toLowerCase()) ||
                element.email.toLowerCase().contains(text.toLowerCase()) ||
                element.totalPurchases
                    .toLowerCase()
                    .contains(text.toLowerCase()));

            if (_foundCustomer.isNotEmpty) {
              for (var customer in _foundCustomer) {
                Customer tempCustomer = Customer(
                    customer.firstName,
                    customer.lastName,
                    customer.id,
                    customer.streetAddress,
                    customer.suiteNum,
                    customer.city,
                    customer.state,
                    customer.zipCode,
                    customer.phoneNumber,
                    customer.email,
                    customer.totalPurchases,
                    customer.bookPurchased,
                    customer.purchasedDates);
                _searchCustomerList.add(tempCustomer);
              }
              setState(() {
                //print(_searchCustomerList.length);
                // customerSearchHelper(context, _searchCustomerList).then((_) {
                //   setState(() {});
                //   //debugPrint('test ${mainBookList.toString()}');
                // });
              });
            } else {
              setState(() {
                _searchCustomerList.clear();
                // customerSearchHelper(context, _searchCustomerList).then((_) {
                //   setState(() {});
                // });
              });
            }
          });
        },
        onSubmitted: (String text) {
          setState(() {});
        },
        autofocus: false,
        maxLines: 1,
        //cursorColor: Colors.white,
        style: const TextStyle(fontSize: 15),
        textAlignVertical: TextAlignVertical.center,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
            filled: true,
            contentPadding: EdgeInsets.zero,
            prefixIcon:
                Icon(Icons.search, color: Theme.of(context).iconTheme.color),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).hintColor)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            hintText: 'Search for existing customers',
            hintStyle:
                TextStyle(fontSize: 15, color: Theme.of(context).hintColor)));
  }

  @override
  Widget build(BuildContext context) {
    subTotalTax = (9 / 100) * subTotal;
    totalCost = subTotal + subTotalTax + shippingCost;

    //Info page height
    if (_customerInfoIndex == 0) {
      _customerInfoHeight = 400;
    } else {
      _customerInfoHeight = 360;
    }
    //Shipping page height
    if (_curShippingOption == ShippingOptions.inStore ||
        _curShippingOption == ShippingOptions.inPerson) {
      _shippingInfoHeight = 330;
    } else if (_curShippingOption != ShippingOptions.inStore ||
        _curShippingOption != ShippingOptions.inPerson) {
      if (_shippingAddressIndex == 1) {
        _shippingInfoHeight = 600;
      } else {
        _shippingInfoHeight = 363;
      }
    }

    Widget checkoutInfo = Column(children: [
      FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                //height: 100,
                padding: const EdgeInsets.only(top: 10, left: 20),
                alignment: Alignment.centerLeft,
                child: FutureBuilder(
                    future: DefaultAssetBundle.of(context)
                        .loadString('assets/jsondatabase/order_data.json'),
                    builder: (context, snapshot) {
                      if (snapshot.data.toString().isNotEmpty &&
                          snapshot.hasData &&
                          mainOrderListCopy.isEmpty) {
                        var jsonResponse = jsonDecode(snapshot.data.toString());
                        convertOrderData(jsonResponse);
                      }

                      //Get orderNum if 0 in orderlist
                      orderNumber = mainOrderListCopy.length + 1;
                      //print('OrderNum: $orderNumber');
                      //Build table
                      return Text(
                        'Order #${orderNumber}',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 30),
                      );
                    })),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: const Text(
                    'Salesperson:',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
                  height: 40,
                  width: 250,
                  child: FutureBuilder(
                      future: DefaultAssetBundle.of(context)
                          .loadString('assets/jsondatabase/employee_data.json'),
                      builder: (context, snapshot) {
                        if (snapshot.data.toString().isNotEmpty &&
                            snapshot.hasData &&
                            mainEmployeeListCopy.isEmpty) {
                          var jsonResponse =
                              jsonDecode(snapshot.data.toString());
                          convertEmployeeData(jsonResponse);
                          if (mainEmployeeListCopy.isNotEmpty) {
                            _employeesDropDownVal.clear();
                            for (var employee in mainEmployeeListCopy) {
                              _employeesDropDownVal.add(employee.firstName +
                                  ' ' +
                                  employee.lastName +
                                  ' - ' +
                                  employee.id);
                            }
                          }
                        }
                        //Build table
                        return CustomDropdownButton2(
                          hint: 'Select Employee',
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border:
                                Border.all(color: Theme.of(context).cardColor),
                            //color: Colors.redAccent,
                          ),
                          buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border:
                                Border.all(color: Theme.of(context).hintColor),
                            //color: Colors.redAccent,
                          ),
                          dropdownElevation: 3,
                          offset: const Offset(-20, 0),
                          hintAlignment: Alignment.center,
                          valueAlignment: Alignment.center,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 20,
                          dropdownWidth: 250,
                          dropdownHeight: double.maxFinite,
                          dropdownItems: _employeesDropDownVal,
                          value: _curEmployeeChoice,
                          onChanged: (value) {
                            setState(() {
                              _curEmployeeChoice = value;
                              List<String> _getEmployeeInfo =
                                  value.toString().split(' - ');
                              List<String> _getEmployeeName =
                                  _getEmployeeInfo.first.split(' ');
                              curSalesperson = mainEmployeeListCopy.firstWhere(
                                  (element) =>
                                      element.id == _getEmployeeInfo.last &&
                                      element.firstName ==
                                          _getEmployeeName.first &&
                                      element.lastName ==
                                          _getEmployeeName.last);
                            });
                          },
                        );
                      }),
                )
              ],
            )
          ],
        ),
      ),
      //Order time
      Container(
        padding: const EdgeInsets.only(left: 25),
        alignment: Alignment.centerLeft,
        child: Text('Order date: $_orderDate'),
      ),
      FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: Expanded(
            child: SingleChildScrollView(
                controller: ScrollController(),
                child: Container(
                    padding: const EdgeInsets.only(top: 0, left: 5, right: 5),
                    //color: Colors.amber,
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: const Text(
                            'Customer',
                            style: TextStyle(fontSize: 20),
                          ),
                          //subtitle: Text('Trailing expansion arrow icon'),
                          initiallyExpanded: true,
                          children: <Widget>[
                            Container(
                              height: _customerInfoHeight,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        //color: Colors.amber,
                                        child: Text('Billing Info:',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .hintColor)),
                                      ),
                                      // Padding(
                                      //   padding:
                                      //       const EdgeInsets.only(right: 15.0),
                                      //   child: ToggleSwitch(
                                      //     minWidth: 78.0,
                                      //     minHeight: 25,
                                      //     borderColor: [
                                      //       Theme.of(context).primaryColorLight
                                      //     ],
                                      //     borderWidth: 1.0,
                                      //     initialLabelIndex: _customerInfoIndex,
                                      //     cornerRadius: 50.0,
                                      //     activeFgColor: Colors.white,
                                      //     inactiveBgColor: Colors.grey,
                                      //     inactiveFgColor: Colors.white,
                                      //     totalSwitches: 2,
                                      //     labels: const ['Returned', 'New'],
                                      //     // activeBgColors: const [
                                      //     //   [Colors.blue],
                                      //     //   [Colors.pink]
                                      //     // ],
                                      //     onToggle: (index) {
                                      //       if (index == 0) {
                                      //         _customerInfoIndex = 0;
                                      //         setState(() {});
                                      //       } else if (index == 1) {
                                      //         _customerInfoIndex = 1;
                                      //         setState(() {});
                                      //       }
                                      //     },
                                      //   ),
                                      // )
                                    ],
                                  ),
                                  //Returned customer
                                  if (_customerInfoIndex == 0)
                                    Expanded(
                                      child: Column(children: [
                                        FutureBuilder(
                                            future: DefaultAssetBundle.of(
                                                    context)
                                                .loadString(
                                                    'assets/jsondatabase/customer_data.json'),
                                            builder: (context, snapshot) {
                                              if (snapshot.data
                                                      .toString()
                                                      .isNotEmpty &&
                                                  snapshot.hasData &&
                                                  mainCustomerListCopy
                                                      .isEmpty) {
                                                var jsonResponse = jsonDecode(
                                                    snapshot.data.toString());
                                                convertCustomerData(
                                                    jsonResponse);
                                              }
                                              //Build table
                                              return Container(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    left: 20,
                                                    right: 15),
                                                height: 40,
                                                child: _searchField(),
                                              );
                                            }),
                                        Expanded(
                                            child: Stack(
                                          children: [
                                            //Info fields
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    //Name
                                                    Expanded(
                                                        child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 10),
                                                      child: TextFormField(
                                                          controller:
                                                              existingCustomerInfoControllers[
                                                                  0],
                                                          decoration:
                                                              const InputDecoration(
                                                            //icon: Icon(Icons.person),
                                                            hintText: '',
                                                            labelText:
                                                                'First Name*',
                                                          )),
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 15),
                                                      child: TextFormField(
                                                          controller:
                                                              existingCustomerInfoControllers[
                                                                  1],
                                                          decoration:
                                                              const InputDecoration(
                                                            //icon: Icon(Icons.person),
                                                            hintText: '',
                                                            labelText:
                                                                'Last Name*',
                                                          )),
                                                    )),
                                                  ],
                                                ),
                                                //Address
                                                Row(children: [
                                                  Expanded(
                                                      child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 15),
                                                    width:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2),
                                                    child: TextFormField(
                                                        controller:
                                                            existingCustomerInfoControllers[
                                                                3],
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText: '',
                                                          labelText:
                                                              'Street Address*',
                                                        )),
                                                  )),
                                                ]),
                                                //Address 2
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    //Name
                                                    Expanded(
                                                        child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 10),
                                                      child: TextFormField(
                                                          controller:
                                                              existingCustomerInfoControllers[
                                                                  4],
                                                          decoration:
                                                              const InputDecoration(
                                                            //icon: Icon(Icons.person),
                                                            hintText: '',
                                                            labelText:
                                                                'Suite / Apt #',
                                                          )),
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 15),
                                                      child: TextFormField(
                                                          controller:
                                                              existingCustomerInfoControllers[
                                                                  5],
                                                          decoration:
                                                              const InputDecoration(
                                                            //icon: Icon(Icons.person),
                                                            hintText: '',
                                                            labelText: 'City*',
                                                          )),
                                                    )),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    //Name
                                                    Expanded(
                                                        child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 10),
                                                      child: TextFormField(
                                                          controller:
                                                              existingCustomerInfoControllers[
                                                                  6],
                                                          decoration:
                                                              const InputDecoration(
                                                            //icon: Icon(Icons.person),
                                                            hintText: '',
                                                            labelText: 'State*',
                                                          )),
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 15),
                                                      child: TextFormField(
                                                          controller:
                                                              existingCustomerInfoControllers[
                                                                  7],
                                                          decoration:
                                                              const InputDecoration(
                                                            //icon: Icon(Icons.person),
                                                            hintText: '',
                                                            labelText:
                                                                'Postal Code*',
                                                          )),
                                                    )),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    //Name
                                                    Expanded(
                                                        child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 10),
                                                      child: TextFormField(
                                                          controller:
                                                              existingCustomerInfoControllers[
                                                                  8],
                                                          decoration:
                                                              const InputDecoration(
                                                            //icon: Icon(Icons.person),
                                                            hintText: '',
                                                            labelText:
                                                                'Phone Number*',
                                                          )),
                                                    )),
                                                    Expanded(
                                                        child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              right: 15),
                                                      child: TextFormField(
                                                          controller:
                                                              existingCustomerInfoControllers[
                                                                  2],
                                                          decoration:
                                                              const InputDecoration(
                                                            //icon: Icon(Icons.person),
                                                            hintText: '',
                                                            labelText: 'ID*',
                                                          )),
                                                    )),
                                                  ],
                                                ),
                                                Row(children: [
                                                  Expanded(
                                                      child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 15),
                                                    width:
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2),
                                                    child: TextFormField(
                                                        controller:
                                                            existingCustomerInfoControllers[
                                                                9],
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText: '',
                                                          labelText: 'Email',
                                                        )),
                                                  )),
                                                ]),
                                              ],
                                            ),
                                            //Search results
                                            if (_searchCustomerController
                                                .text.isNotEmpty)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 2),
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20, right: 15),
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxHeight:
                                                              double.maxFinite),
                                                  //color: Colors.amber,
                                                  height: (75 *
                                                      double.parse(
                                                          _searchCustomerList
                                                              .length
                                                              .toString())),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            right: 15),
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .dialogBackgroundColor,
                                                        borderRadius: const BorderRadius
                                                                .only(
                                                            topLeft: Radius
                                                                .circular(0),
                                                            topRight:
                                                                Radius.circular(
                                                                    0),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    3),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    3)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Theme.of(
                                                                    context)
                                                                .hintColor
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 1,
                                                            blurRadius: 1,
                                                            offset: const Offset(
                                                                0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ]),
                                                    child: ListView(
                                                      controller:
                                                          ScrollController(),
                                                      children: [
                                                        for (var customer
                                                            in _searchCustomerList)
                                                          Container(
                                                            height: 75,
                                                            child: Card(
                                                              elevation: 3,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      side:
                                                                          BorderSide(
                                                                        color: Theme.of(context)
                                                                            .hintColor
                                                                            .withOpacity(0.3),
                                                                        //color: Colors.grey.withOpacity(0.2),
                                                                        width:
                                                                            1,
                                                                      )),
                                                              child: ListTile(
                                                                dense: true,
                                                                //contentPadding: EdgeInsets.symmetric(vertical: 0),
                                                                onTap: () {
                                                                  existingCustomerInfoControllers[
                                                                              0]
                                                                          .text =
                                                                      customer
                                                                          .firstName;
                                                                  existingCustomerInfoControllers[
                                                                              1]
                                                                          .text =
                                                                      customer
                                                                          .lastName;
                                                                  existingCustomerInfoControllers[
                                                                              2]
                                                                          .text =
                                                                      customer
                                                                          .id;
                                                                  existingCustomerInfoControllers[
                                                                              3]
                                                                          .text =
                                                                      customer
                                                                          .streetAddress;
                                                                  existingCustomerInfoControllers[
                                                                              4]
                                                                          .text =
                                                                      customer
                                                                          .suiteNum;
                                                                  existingCustomerInfoControllers[
                                                                              5]
                                                                          .text =
                                                                      customer
                                                                          .city;
                                                                  existingCustomerInfoControllers[
                                                                              6]
                                                                          .text =
                                                                      customer
                                                                          .state;
                                                                  existingCustomerInfoControllers[
                                                                              7]
                                                                          .text =
                                                                      customer
                                                                          .zipCode;
                                                                  existingCustomerInfoControllers[
                                                                              8]
                                                                          .text =
                                                                      customer
                                                                          .phoneNumber;
                                                                  existingCustomerInfoControllers[
                                                                              9]
                                                                          .text =
                                                                      customer
                                                                          .email;

                                                                  curOrderingCustomer =
                                                                      customer;
                                                                  _searchCustomerController
                                                                      .clear();

                                                                  setState(
                                                                      () {});
                                                                },
                                                                leading: const Icon(
                                                                    Icons
                                                                        .person),
                                                                title: Text(
                                                                  '${customer.firstName} ${customer.lastName}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                                subtitle: Text(
                                                                  '${_getFullAddress(customer)}\n${customer.phoneNumber}',
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                        Icons
                                                                            .add),
                                                                isThreeLine:
                                                                    true,
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ))
                                      ]),
                                    ),
                                  //New customer
                                  // if (_customerInfoIndex == 1)
                                  //   Expanded(
                                  //       child: Column(
                                  //     children: [
                                  //       Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.start,
                                  //         children: [
                                  //           //Name
                                  //           Expanded(
                                  //               child: Container(
                                  //             padding: const EdgeInsets.only(
                                  //                 left: 20, right: 10),
                                  //             child: TextFormField(
                                  //                 decoration:
                                  //                     const InputDecoration(
                                  //               //icon: Icon(Icons.person),
                                  //               hintText: '',
                                  //               labelText: 'First Name*',
                                  //             )),
                                  //           )),
                                  //           Expanded(
                                  //               child: Container(
                                  //             padding: const EdgeInsets.only(
                                  //                 left: 10, right: 15),
                                  //             child: TextFormField(
                                  //                 decoration:
                                  //                     const InputDecoration(
                                  //               //icon: Icon(Icons.person),
                                  //               hintText: '',
                                  //               labelText: 'Last Name*',
                                  //             )),
                                  //           )),
                                  //         ],
                                  //       ),
                                  //       //Address
                                  //       Row(children: [
                                  //         Expanded(
                                  //             child: Container(
                                  //           padding: const EdgeInsets.only(
                                  //               left: 20, right: 15),
                                  //           width: (MediaQuery.of(context)
                                  //                   .size
                                  //                   .width /
                                  //               2),
                                  //           child: TextFormField(
                                  //               decoration:
                                  //                   const InputDecoration(
                                  //             hintText: '',
                                  //             labelText: 'Street Address*',
                                  //           )),
                                  //         )),
                                  //       ]),
                                  //       //Address 2
                                  //       Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.start,
                                  //         children: [
                                  //           //Name
                                  //           Expanded(
                                  //               child: Container(
                                  //             padding: const EdgeInsets.only(
                                  //                 left: 20, right: 10),
                                  //             child: TextFormField(
                                  //                 decoration:
                                  //                     const InputDecoration(
                                  //               //icon: Icon(Icons.person),
                                  //               hintText: '',
                                  //               labelText: 'Suite / Apt #',
                                  //             )),
                                  //           )),
                                  //           Expanded(
                                  //               child: Container(
                                  //             padding: const EdgeInsets.only(
                                  //                 left: 10, right: 15),
                                  //             child: TextFormField(
                                  //                 decoration:
                                  //                     const InputDecoration(
                                  //               //icon: Icon(Icons.person),
                                  //               hintText: '',
                                  //               labelText: 'City*',
                                  //             )),
                                  //           )),
                                  //         ],
                                  //       ),
                                  //       Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.start,
                                  //         children: [
                                  //           //Name
                                  //           Expanded(
                                  //               child: Container(
                                  //             padding: const EdgeInsets.only(
                                  //                 left: 20, right: 10),
                                  //             child: TextFormField(
                                  //                 decoration:
                                  //                     const InputDecoration(
                                  //               //icon: Icon(Icons.person),
                                  //               hintText: '',
                                  //               labelText: 'State*',
                                  //             )),
                                  //           )),
                                  //           Expanded(
                                  //               child: Container(
                                  //             padding: const EdgeInsets.only(
                                  //                 left: 10, right: 15),
                                  //             child: TextFormField(
                                  //                 decoration:
                                  //                     const InputDecoration(
                                  //               //icon: Icon(Icons.person),
                                  //               hintText: '',
                                  //               labelText: 'Postal Code*',
                                  //             )),
                                  //           )),
                                  //         ],
                                  //       ),
                                  //       Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.start,
                                  //         children: [
                                  //           //Name
                                  //           Expanded(
                                  //               child: Container(
                                  //             padding: const EdgeInsets.only(
                                  //                 left: 20, right: 10),
                                  //             child: TextFormField(
                                  //                 decoration:
                                  //                     const InputDecoration(
                                  //               //icon: Icon(Icons.person),
                                  //               hintText: '',
                                  //               labelText: 'Phone Number*',
                                  //             )),
                                  //           )),
                                  //           Expanded(
                                  //               child: Container(
                                  //             padding: const EdgeInsets.only(
                                  //                 left: 10, right: 15),
                                  //             child: TextFormField(
                                  //                 decoration:
                                  //                     const InputDecoration(
                                  //               //icon: Icon(Icons.person),
                                  //               hintText: '',
                                  //               labelText: 'ID*',
                                  //             )),
                                  //           )),
                                  //         ],
                                  //       ),
                                  //       Row(children: [
                                  //         Expanded(
                                  //             child: Container(
                                  //           padding: const EdgeInsets.only(
                                  //               left: 20, right: 15),
                                  //           width: (MediaQuery.of(context)
                                  //                   .size
                                  //                   .width /
                                  //               2),
                                  //           child: TextFormField(
                                  //               decoration:
                                  //                   const InputDecoration(
                                  //             hintText: '',
                                  //             labelText: 'Email',
                                  //           )),
                                  //         )),
                                  //       ]),
                                  //     ],
                                  //   ))
                                ],
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Delivery Options',
                            style: TextStyle(fontSize: 20),
                          ),
                          //subtitle: Text('Trailing expansion arrow icon'),
                          initiallyExpanded: true,
                          children: <Widget>[
                            Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 15),
                                width: double.infinity,
                                height: _shippingInfoHeight,
                                child: Column(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        child: RadioListTile(
                                            title: const Text(
                                                'In Person (Immediate)'),
                                            subtitle: const Text('Free'),
                                            secondary: const Text('\$0.00'),
                                            value: ShippingOptions.inPerson,
                                            groupValue: _curShippingOption,
                                            onChanged:
                                                (ShippingOptions? value) {
                                              setState(() {
                                                _curShippingOption = value;
                                                shippingCost = 0.00;
                                                _deliveryDate = _orderDate;
                                                _orderStatus =
                                                    _orderStatusList[0];
                                              });
                                            })),
                                    Container(
                                        width: double.infinity,
                                        child: RadioListTile(
                                            title:
                                                const Text('In-Store Pickup'),
                                            subtitle: const Text('Free'),
                                            secondary: const Text('\$0.00'),
                                            value: ShippingOptions.inStore,
                                            groupValue: _curShippingOption,
                                            onChanged:
                                                (ShippingOptions? value) {
                                              setState(() {
                                                _curShippingOption = value;
                                                shippingCost = 0.00;
                                                _deliveryDate = _orderDate;
                                                _orderStatus =
                                                    _orderStatusList[1];
                                              });
                                            })),
                                    Container(
                                        width: double.infinity,
                                        child: RadioListTile(
                                            title:
                                                const Text('Next Day Shipping'),
                                            subtitle:
                                                const Text('1 Business Day'),
                                            secondary: const Text('\$30.00'),
                                            value: ShippingOptions.nextDay,
                                            groupValue: _curShippingOption,
                                            onChanged:
                                                (ShippingOptions? value) {
                                              setState(() {
                                                _curShippingOption = value;
                                                shippingCost = 30.00;
                                                final _deliverTimeGet =
                                                    DateTime(
                                                        now.year,
                                                        now.month,
                                                        now.day + 1,
                                                        now.hour,
                                                        now.minute);
                                                _deliveryDate = DateFormat(
                                                        'MM-dd-yyyy HH:mm')
                                                    .format(_deliverTimeGet);
                                                _orderStatus =
                                                    _orderStatusList[2];
                                              });
                                            })),
                                    Container(
                                        width: double.infinity,
                                        child: RadioListTile(
                                            title:
                                                const Text('Express Shipping'),
                                            subtitle: const Text(
                                                '2 - 3 Business Days'),
                                            secondary: const Text('\$20.00'),
                                            value: ShippingOptions.express,
                                            groupValue: _curShippingOption,
                                            onChanged:
                                                (ShippingOptions? value) {
                                              setState(() {
                                                _curShippingOption = value;
                                                shippingCost = 20.00;
                                                final _deliverTimeGet =
                                                    DateTime(
                                                        now.year,
                                                        now.month,
                                                        now.day + 3,
                                                        now.hour,
                                                        now.minute);
                                                _deliveryDate = DateFormat(
                                                        'MM-dd-yyyy HH:mm')
                                                    .format(_deliverTimeGet);
                                                _orderStatus =
                                                    _orderStatusList[2];
                                              });
                                            })),
                                    Container(
                                        width: double.infinity,
                                        child: RadioListTile(
                                            title:
                                                const Text('Standard Shipping'),
                                            subtitle: const Text(
                                                '4 - 6 Business Days'),
                                            secondary: const Text('\$10.00'),
                                            value: ShippingOptions.standard,
                                            groupValue: _curShippingOption,
                                            onChanged:
                                                (ShippingOptions? value) {
                                              setState(() {
                                                _curShippingOption = value;
                                                shippingCost = 10.00;
                                                final _deliverTimeGet =
                                                    DateTime(
                                                        now.year,
                                                        now.month,
                                                        now.day + 6,
                                                        now.hour,
                                                        now.minute);
                                                _deliveryDate = DateFormat(
                                                        'MM-dd-yyyy HH:mm')
                                                    .format(_deliverTimeGet);
                                                _orderStatus =
                                                    _orderStatusList[2];
                                              });
                                            })),
                                    //Shipping Adress
                                    if (_curShippingOption !=
                                            ShippingOptions.inStore &&
                                        _curShippingOption !=
                                            ShippingOptions.inPerson)
                                      Divider(
                                        height: 10,
                                        thickness: 1,
                                        indent: 10,
                                        endIndent: 10,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    if (_curShippingOption !=
                                            ShippingOptions.inStore &&
                                        _curShippingOption !=
                                            ShippingOptions.inPerson)
                                      ToggleSwitch(
                                        minWidth: 200.0,
                                        minHeight: 25,
                                        borderColor: [
                                          Theme.of(context).primaryColorLight
                                        ],
                                        borderWidth: 1.0,
                                        initialLabelIndex:
                                            _shippingAddressIndex,
                                        cornerRadius: 50.0,
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey,
                                        inactiveFgColor: Colors.white,
                                        totalSwitches: 2,
                                        labels: const [
                                          'Same as Billing',
                                          'Ship to another address'
                                        ],
                                        // activeBgColors: const [
                                        //   [Colors.blue],
                                        //   [Colors.pink]
                                        // ],
                                        onToggle: (index) {
                                          if (index == 0) {
                                            _shippingAddressIndex = 0;
                                            setState(() {});
                                          } else if (index == 1) {
                                            _shippingAddressIndex = 1;
                                            setState(() {});
                                          }
                                        },
                                      ),

                                    //Address if ship to other
                                    if (_shippingAddressIndex == 1 &&
                                        _curShippingOption !=
                                            ShippingOptions.inStore)
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              //Name
                                              Expanded(
                                                  child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 10),
                                                child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                  //icon: Icon(Icons.person),
                                                  hintText: '',
                                                  labelText: 'First Name*',
                                                )),
                                              )),
                                              Expanded(
                                                  child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 15),
                                                child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                  //icon: Icon(Icons.person),
                                                  hintText: '',
                                                  labelText: 'Last Name*',
                                                )),
                                              )),
                                            ],
                                          ),
                                          //Address
                                          Row(children: [
                                            Expanded(
                                                child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 15),
                                              width: (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2),
                                              child: TextFormField(
                                                  decoration:
                                                      const InputDecoration(
                                                hintText: '',
                                                labelText: 'Street Address*',
                                              )),
                                            )),
                                          ]),
                                          //Address 2
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              //Name
                                              Expanded(
                                                  child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 10),
                                                child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                  //icon: Icon(Icons.person),
                                                  hintText: '',
                                                  labelText: 'Suite / Apt #',
                                                )),
                                              )),
                                              Expanded(
                                                  child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 15),
                                                child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                  //icon: Icon(Icons.person),
                                                  hintText: '',
                                                  labelText: 'City*',
                                                )),
                                              )),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              //Name
                                              Expanded(
                                                  child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 10),
                                                child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                  //icon: Icon(Icons.person),
                                                  hintText: '',
                                                  labelText: 'State*',
                                                )),
                                              )),
                                              Expanded(
                                                  child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 15),
                                                child: TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                  //icon: Icon(Icons.person),
                                                  hintText: '',
                                                  labelText: 'Postal Code*',
                                                )),
                                              )),
                                            ],
                                          ),
                                        ],
                                      ))
                                  ],
                                ))
                          ],
                        ),
                        ExpansionTile(
                          title: const Text(
                            'Payment Methods',
                            style: TextStyle(fontSize: 20),
                          ),
                          //subtitle: Text('Trailing expansion arrow icon'),
                          initiallyExpanded: true,
                          children: <Widget>[
                            Container(
                              height: 500,
                              child: Column(
                                children: [
                                  const Padding(
                                      padding: EdgeInsets.only(top: 5)),
                                  ToggleSwitch(
                                    minWidth: 60.0,
                                    minHeight: 36.0,
                                    cornerRadius: 0.0,
                                    //borderWidth: 1,
                                    //borderColor: [Theme.of(context).hintColor],
                                    // activeBgColors: const [
                                    //   [Color(0xfffdbb0a)],
                                    //   [Colors.black54],
                                    //   [Colors.white54]
                                    // ],
                                    //inactiveFgColor: Colors.blue,
                                    inactiveBgColor:
                                        Theme.of(context).canvasColor,
                                    initialLabelIndex: 0,
                                    totalSwitches: 5,
                                    customIcons: const [
                                      Icon(
                                        FontAwesomeIcons.moneyBill1,
                                        //color: Color.fromARGB(255, 214, 226, 103),
                                        size: 30,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.ccVisa,
                                        //color: Colors.yellow,
                                        size: 30,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.ccMastercard,
                                        //color: Color(0xffF79E1B),
                                        size: 30,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.ccAmex,
                                        //color: Color(0xff27AEE3),
                                        size: 30,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.moneyCheckDollar,
                                        //color: Color(0xffF79E1B),
                                        size: 30,
                                      ),
                                    ],
                                    //labels: ['Cash', 'Visa', 'Master Card', 'American\nExpress'],
                                    onToggle: (index) {
                                      if (index == 0) {
                                        curPaymentMethod = 'Cash';
                                      } else if (index == 1) {
                                        curPaymentMethod = 'Visa';
                                      } else if (index == 2) {
                                        curPaymentMethod = 'Master Card';
                                      } else if (index == 3) {
                                        curPaymentMethod = 'American Express';
                                      } else if (index == 4) {
                                        curPaymentMethod = 'Money Check';
                                      }

                                      //print('switched to: $index');
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )))),
      ),
    ]);

    Widget orderSummary = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20, top: 10),
              alignment: Alignment.centerLeft,
              child: const Text(
                'Order Summary',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
              padding: const EdgeInsets.only(top: 15, right: 0, bottom: 5),
              //color: Colors.blue,
              width: double.infinity,
              child: SingleChildScrollView(
                  controller: ScrollController(),
                  child: Column(
                    children: [
                      for (int i = 0; i < checkoutCartList.length; i++)
                        Container(
                            padding: const EdgeInsets.only(
                                top: 0, left: 5, right: 10, bottom: 0),
                            height: 190,
                            child: Card(
                              elevation: 3,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.3),
                                  //color: Colors.grey.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.menu_book),
                                    title: Text(
                                      checkoutCartList[i].title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      checkoutCartList[i].author,
                                      // style: TextStyle(
                                      //     color: Colors.black.withOpacity(0.6)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text('ID: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(checkoutCartList[i].id),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10)),
                                            const Text('Edition: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(checkoutCartList[i].edition),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10)),
                                          ],
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 5)),
                                        Row(
                                          children: [
                                            const Text('Publisher: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(checkoutCartList[i].publisher),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10)),
                                            const Text('Date: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(checkoutCartList[i]
                                                .publishDate),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10)),
                                          ],
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 5)),
                                        Row(
                                          children: [
                                            const Text('Condition: ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(checkoutCartList[i].condition),
                                            const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [
                                        const Text(
                                          'Price: ',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(
                                          //padding: const EdgeInsets.only(top: 5),
                                          width: 70,
                                          height: 25,
                                          child: TextField(
                                            controller: priceControllers[i],
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(8)),
                                            onChanged: (value) {
                                              subTotal -= double.parse(
                                                  checkoutPrices[i]);
                                              subTotal += double.parse(value);
                                              checkoutPrices[i] = value;

                                              // checkoutCartList[i].retailPrice =
                                              //     value;
                                              setState(() {});
                                            },
                                            onSubmitted: (value) {
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ]),
                                      //Remove button
                                      TextButton(
                                        onPressed: () {
                                          subTotal -=
                                              double.parse(checkoutPrices[i]);
                                          checkoutCartList[i].sold =
                                              'Available';
                                          checkoutCartList.removeAt(i);
                                          checkoutPrices.removeAt(i);
                                          priceControllers.removeAt(i);
                                          MenuItems.getItems(checkoutCartList);

                                          setState(() {});
                                        },
                                        child: const Text('Remove'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                    ],
                  ))),
        ),
        Divider(
          height: 5,
          thickness: 1,
          indent: 10,
          endIndent: 10,
          color: Theme.of(context).hintColor,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            //color: Colors.red,
            width: double.infinity,
            height: 190,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Left column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: const Text(
                              'Subtotal:',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 19),
                            )),
                        Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: const Text(
                              'Shipping:',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 17),
                            )),
                        Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: const Text(
                              'Tax:',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 17),
                            )),
                        Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: const Text(
                              'Total:',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 20),
                            )),
                      ],
                    ),
                    //Right column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              '\$${subTotal.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 19),
                            )),
                        Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '\$${shippingCost.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 17),
                            )),
                        Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '\$${subTotalTax.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 17),
                            )),
                        Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '\$${totalCost.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 20),
                            )),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10, right: 5),
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).hintColor,
                              padding: const EdgeInsets.only(bottom: 9)),
                          child: const Text(
                            'Cancel',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            setState(() {
                              subTotal = 0.00;
                              for (var book in checkoutCartList) {
                                book.sold = 'Available';
                              }
                              _curShippingOption = ShippingOptions.inStore;
                              checkoutCartList.clear();
                              checkoutPrices.clear();
                              priceControllers.clear();
                              MenuItems.booksMenu.clear();

                              context.read<checkoutNotif>().checkoutOff();
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(top: 10, left: 5),
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              padding: const EdgeInsets.only(bottom: 9)),
                          child: const Text(
                            'Submit Order',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            setState(() {
                              //Add database here
                              subTotal = 0.00;
                              //print('checkout $orderNumber');

                              //Update Order page
                              Order newOrder = Order(
                                  orderNumber.toString(),
                                  '${curOrderingCustomer.firstName} ${curOrderingCustomer.lastName}',
                                  curOrderingCustomer.id,
                                  '${curSalesperson.firstName} ${curSalesperson.lastName}',
                                  curSalesperson.id,
                                  _orderDate,
                                  _deliveryDate,
                                  totalCost.toStringAsFixed(2),
                                  curPaymentMethod,
                                  _orderStatus,
                                  '',
                                  '');
                              String _allBookIDs = '';
                              int _numOfBook = 0;
                              for (var book in checkoutCartList) {
                                //book.sold = 'Available';
                                _numOfBook++;
                                if (curOrderingCustomer
                                    .bookPurchased.isEmpty) {
                                  curOrderingCustomer.bookPurchased =
                                      book.title;
                                  curOrderingCustomer.purchasedDates =
                                      _orderDate;                        
                                } else {
                                  curOrderingCustomer.bookPurchased =
                                      curOrderingCustomer.bookPurchased +
                                          ' ' +
                                          book.title;
                                  curOrderingCustomer.purchasedDates =
                                      curOrderingCustomer.purchasedDates +
                                          ' ' +
                                          _orderDate;
                                }

                                if (_allBookIDs.isNotEmpty) {
                                  _allBookIDs = _allBookIDs + ' ' + book.id;
                                } else {
                                  _allBookIDs = book.id;
                                }
                              }

                              String _allSoldPrices = '';
                              for (var price in checkoutPrices) {
                                if (_allSoldPrices.isNotEmpty) {
                                  _allSoldPrices = _allSoldPrices + ' ' + price;
                                } else {
                                  _allSoldPrices = price;
                                }
                              }
                              newOrder.bookIds = _allBookIDs;
                              newOrder.bookSoldPrices = _allSoldPrices;

                              //Sales record update
                              if (mainSalesRecordListCopy.isEmpty) {
                                for (int i = 0;
                                    i < checkoutCartList.length;
                                    i++) {
                                  SalesRecord newRecord = SalesRecord(
                                      checkoutCartList[i].title,
                                      checkoutCartList[i].id,
                                      '${curOrderingCustomer.firstName} ${curOrderingCustomer.lastName}',
                                      curOrderingCustomer.id,
                                      '${curSalesperson.firstName} ${curSalesperson.lastName}',
                                      curSalesperson.id,
                                      checkoutPrices[i],
                                      _orderDate,
                                      _deliveryDate);
                                  mainSalesRecordList.add(newRecord);
                                  mainSalesRecordListCopy.add(newRecord);
                                }
                              } else {
                                for (int i = 0;
                                    i < checkoutCartList.length;
                                    i++) {
                                  final existingBookIndex =
                                      mainSalesRecordListCopy.indexWhere(
                                          (element) =>
                                              element.bookId ==
                                              checkoutCartList[i].id);
                                  if (existingBookIndex == -1) {
                                    SalesRecord newRecord = SalesRecord(
                                        checkoutCartList[i].title,
                                        checkoutCartList[i].id,
                                        '${curOrderingCustomer.firstName} ${curOrderingCustomer.lastName}',
                                        curOrderingCustomer.id,
                                        '${curSalesperson.firstName} ${curSalesperson.lastName}',
                                        curSalesperson.id,
                                        checkoutPrices[i],
                                        _orderDate,
                                        _deliveryDate);
                                    mainSalesRecordList.add(newRecord);
                                    mainSalesRecordListCopy.add(newRecord);
                                  }
                                }
                              }

                              //General updates
                              mainOrderList.add(newOrder);
                              mainOrderListCopy.add(newOrder);
                              curSalesperson.numBookSold =
                                  (int.parse(curSalesperson.numBookSold) +
                                          _numOfBook)
                                      .toString();
                              curOrderingCustomer.totalPurchases = (int.parse(
                                          curOrderingCustomer.totalPurchases) +
                                      _numOfBook)
                                  .toString();
                              final _curCustomerFromData =
                                  mainCustomerListCopy.firstWhere((element) =>
                                      element.id == curOrderingCustomer.id);
                              _curCustomerFromData.totalPurchases =
                                  curOrderingCustomer.totalPurchases;

                              _curShippingOption = ShippingOptions.inStore;
                              checkoutCartList.clear();
                              checkoutPrices.clear();
                              priceControllers.clear();
                              MenuItems.booksMenu.clear();
                              //orderNumber++;

                              context.read<checkoutNotif>().checkoutOff();

                              //Save to databases
                              if (!kIsWeb) {
                                mainCustomerListCopy
                                    .map(
                                      (customer) => customer.toJson(),
                                    )
                                    .toList();
                                customerDataJson.writeAsStringSync(
                                    json.encode(mainCustomerListCopy));

                                mainEmployeeListCopy
                                    .map(
                                      (employee) => employee.toJson(),
                                    )
                                    .toList();
                                employeeDataJson.writeAsStringSync(
                                    json.encode(mainEmployeeListCopy));

                                mainBookListCopy
                                    .map(
                                      (book) => book.toJson(),
                                    )
                                    .toList();
                                bookDataJson.writeAsStringSync(
                                    json.encode(mainBookListCopy));

                                mainOrderListCopy
                                    .map(
                                      (order) => order.toJson(),
                                    )
                                    .toList();
                                orderDataJson.writeAsStringSync(
                                    json.encode(mainOrderListCopy));

                                mainSalesRecordListCopy
                                    .map(
                                      (salesRecord) => salesRecord.toJson(),
                                    )
                                    .toList();
                                salesRecordDataJson.writeAsStringSync(
                                    json.encode(mainSalesRecordListCopy));
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ],
    );

    MultiSplitView checkoutSplitView = MultiSplitView(
        controller: _checkoutMvController,
        axis: Axis.horizontal,
        children: [
          MultiSplitView(
            children: [checkoutInfo, orderSummary],
            initialWeights: const [0.55],
            minimalWeight: 0.45,
          ),
        ]);

    MultiSplitViewTheme theme = MultiSplitViewTheme(
        child: checkoutSplitView,
        data: MultiSplitViewThemeData(
            dividerPainter: DividerPainters.dashed(
                //highlightedSize: 500,
                //size: 150,
                color: Theme.of(context).hintColor,
                highlightedColor:
                    Theme.of(context).textTheme.bodyText1!.color)));

    return Scaffold(
      body: Column(children: [Expanded(child: theme)]),
    );
  }
}
