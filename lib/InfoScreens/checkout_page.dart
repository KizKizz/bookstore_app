import 'dart:convert';

import 'package:bookstore_project/Data/book_data_handler.dart';
import 'package:bookstore_project/InfoScreens/book_list.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../Data/customer_data_helper.dart';
import '../Data/employee_data_handler.dart';
import '../state_provider.dart';

List<String> _employeesDropDownVal = [];
String? _curEmployeeChoice;
int _customerInfoIndex = 0;
int _shippingAddressIndex = 0;
int orderNumber = 1;

double subTotal = 0.0;
double shippingCost = 0.0;
double subTotalTax = 0.0;
double totalCost = 0.0;

List<TextEditingController> priceControllers = [];
List<TextEditingController> existingCustomerInfoControllers = [];
List<String> checkoutPrices = [];

DateTime now = DateTime.now();
String _orderDate = DateFormat('MM-dd-yyyy HH:mm').format(now);

enum ShippingOptions { inStore, nextDay, express, standard }

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final MultiSplitViewController _checkoutMvController =
      MultiSplitViewController(weights: [0.65]);

  double _shippingInfoHeight = 280;
  double _customerInfoHeight = 360;
  ShippingOptions? _curShippingOption = ShippingOptions.inStore;
  final _searchCustomerController = TextEditingController();
  List<Customer> _searchCustomerList = [];

  @override
  void initState() {
    super.initState();

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
                    customer.totalPurchases);
                _searchCustomerList.add(tempCustomer);
              }
              setState(() {
                print(_searchCustomerList.length);
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

  // Future<List<Customer>> _getAllCustomers(String text) async {
  //   List<Customer> customers = mainCustomerListCopy
  //       .where((element) =>
  //           element.firstName.contains(text) || element.lastName.contains(text))
  //       .toList();
  //   return customers;
  // }

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
    if (_curShippingOption == ShippingOptions.inStore) {
      _shippingInfoHeight = 280;
    } else if (_curShippingOption != ShippingOptions.inStore) {
      if (_shippingAddressIndex == 1) {
        _shippingInfoHeight = 550;
      } else {
        _shippingInfoHeight = 300;
      }
    }

    Widget checkoutInfo = Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //height: 100,
            padding: const EdgeInsets.only(top: 10, left: 20),
            alignment: Alignment.centerLeft,
            child: Text(
              'Order #$orderNumber',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 30),
            ),
          ),
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
                        var jsonResponse = jsonDecode(snapshot.data.toString());
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
                        dropdownElevation: 3,
                        offset: const Offset(-20, 0),
                        valueAlignment: Alignment.center,
                        icon: const Icon(Icons.arrow_drop_down),
                        dropdownWidth: 250,
                        dropdownItems: _employeesDropDownVal,
                        value: _curEmployeeChoice,
                        onChanged: (value) {
                          setState(() {
                            _curEmployeeChoice = value;
                          });
                        },
                      );
                    }),
              )
            ],
          )
        ],
      ),
      //Order time
      Container(
        padding: const EdgeInsets.only(left: 25),
        alignment: Alignment.centerLeft,
        child: Text('Order date: $_orderDate'),
      ),
      Expanded(
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
                                      padding: const EdgeInsets.only(left: 20),
                                      //color: Colors.amber,
                                      child: Text('Billing Info:',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color:
                                                  Theme.of(context).hintColor)),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: ToggleSwitch(
                                        minWidth: 78.0,
                                        minHeight: 25,
                                        borderColor: [
                                          Theme.of(context).primaryColorLight
                                        ],
                                        borderWidth: 1.5,
                                        initialLabelIndex: _customerInfoIndex,
                                        cornerRadius: 50.0,
                                        activeFgColor: Colors.white,
                                        inactiveBgColor: Colors.grey,
                                        inactiveFgColor: Colors.white,
                                        totalSwitches: 2,
                                        labels: const ['Returned', 'New'],
                                        // activeBgColors: const [
                                        //   [Colors.blue],
                                        //   [Colors.pink]
                                        // ],
                                        onToggle: (index) {
                                          if (index == 0) {
                                            _customerInfoIndex = 0;
                                            setState(() {});
                                          } else if (index == 1) {
                                            _customerInfoIndex = 1;
                                            setState(() {});
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                //Returned customer
                                if (_customerInfoIndex == 0)
                                  Expanded(
                                    child: Column(children: [
                                      FutureBuilder(
                                          future: DefaultAssetBundle.of(context)
                                              .loadString(
                                                  'assets/jsondatabase/customer_data.json'),
                                          builder: (context, snapshot) {
                                            if (snapshot.data
                                                    .toString()
                                                    .isNotEmpty &&
                                                snapshot.hasData &&
                                                mainCustomerListCopy.isEmpty) {
                                              var jsonResponse = jsonDecode(
                                                  snapshot.data.toString());
                                              convertCustomerData(jsonResponse);
                                            }
                                            //Build table
                                            return Container(
                                              padding: const EdgeInsets.only(
                                                  top: 5, left: 20, right: 15),
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
                                                          left: 20, right: 15),
                                                  width: (MediaQuery.of(context)
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
                                                          left: 20, right: 15),
                                                  width: (MediaQuery.of(context)
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
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 15),
                                              //color: Colors.amber,
                                              //height: 400,
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 15, right: 15),
                                                color: Theme.of(context)
                                                    .canvasColor,
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
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  side:
                                                                      BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .hintColor
                                                                        .withOpacity(
                                                                            0.3),
                                                                    //color: Colors.grey.withOpacity(0.2),
                                                                    width: 1,
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
                                                                  customer.id;
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
                                                                  customer.city;
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
                                                              _searchCustomerController
                                                                  .clear();
                                                              setState(() {});
                                                            },
                                                            leading: const Icon(
                                                                Icons.person),
                                                            title: Text(
                                                              '${customer.firstName} ${customer.lastName}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          15),
                                                            ),
                                                            subtitle: Text(
                                                              '${_getFullAddress(customer)}\n${customer.phoneNumber}',
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                            trailing:
                                                                const Icon(
                                                                    Icons.add),
                                                            isThreeLine: true,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                        ],
                                      ))
                                    ]),
                                  ),
                                //New customer
                                if (_customerInfoIndex == 1)
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
                                              decoration: const InputDecoration(
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
                                              labelText: 'Phone Number*',
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
                                              labelText: 'ID*',
                                            )),
                                          )),
                                        ],
                                      ),
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
                                              decoration: const InputDecoration(
                                            hintText: '',
                                            labelText: 'Email',
                                          )),
                                        )),
                                      ]),
                                    ],
                                  ))
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
                                          title: const Text('In-Store Pickup'),
                                          subtitle: const Text('Free'),
                                          secondary: const Text('\$0.00'),
                                          value: ShippingOptions.inStore,
                                          groupValue: _curShippingOption,
                                          onChanged: (ShippingOptions? value) {
                                            setState(() {
                                              _curShippingOption = value;
                                              shippingCost = 0.00;
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
                                          onChanged: (ShippingOptions? value) {
                                            setState(() {
                                              _curShippingOption = value;
                                              shippingCost = 30.00;
                                            });
                                          })),
                                  Container(
                                      width: double.infinity,
                                      child: RadioListTile(
                                          title: const Text('Express Shipping'),
                                          subtitle:
                                              const Text('2 - 3 Business Days'),
                                          secondary: const Text('\$20.00'),
                                          value: ShippingOptions.express,
                                          groupValue: _curShippingOption,
                                          onChanged: (ShippingOptions? value) {
                                            setState(() {
                                              _curShippingOption = value;
                                              shippingCost = 20.00;
                                            });
                                          })),
                                  Container(
                                      width: double.infinity,
                                      child: RadioListTile(
                                          title:
                                              const Text('Standard Shipping'),
                                          subtitle:
                                              const Text('4 - 6 Business Days'),
                                          secondary: const Text('\$10.00'),
                                          value: ShippingOptions.standard,
                                          groupValue: _curShippingOption,
                                          onChanged: (ShippingOptions? value) {
                                            setState(() {
                                              _curShippingOption = value;
                                              shippingCost = 10.00;
                                            });
                                          })),
                                  //Shipping Adress
                                  if (_curShippingOption !=
                                      ShippingOptions.inStore)
                                    Divider(
                                      height: 10,
                                      thickness: 1,
                                      indent: 10,
                                      endIndent: 10,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  if (_curShippingOption !=
                                      ShippingOptions.inStore)
                                    ToggleSwitch(
                                      minWidth: 200.0,
                                      minHeight: 25,
                                      borderColor: [
                                        Theme.of(context).primaryColorLight
                                      ],
                                      borderWidth: 1.5,
                                      initialLabelIndex: _shippingAddressIndex,
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
                      const ExpansionTile(
                        title: Text(
                          'Payment',
                          style: TextStyle(fontSize: 20),
                        ),
                        //subtitle: Text('Trailing expansion arrow icon'),
                        children: <Widget>[
                          ListTile(title: Text('Payment methods go here')),
                        ],
                      ),
                    ],
                  )))),
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
            Container(
              //height: 30,
              //color: Colors.amber,
              padding: const EdgeInsets.only(right: 10, top: 26),
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  subTotal = 0.00;
                  for (var book in checkoutCartList) {
                    book.sold = 'Available';
                  }
                  checkoutCartList.clear();
                  checkoutPrices.clear();
                  priceControllers.clear();
                  MenuItems.booksMenu.clear();

                  setState(() {});
                },
                child: const Text('Remove All'),
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
                              '\$ ${subTotal.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 19),
                            )),
                        Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '\$ ${shippingCost.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 17),
                            )),
                        Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '\$ ${subTotalTax.toStringAsFixed(2)}',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 17),
                            )),
                        Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '\$ ${totalCost.toStringAsFixed(2)}',
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
                              padding: const EdgeInsets.only(bottom: 10)),
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
                              padding: const EdgeInsets.only(bottom: 10)),
                          child: const Text(
                            'Submit Order',
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            setState(() {
                              orderNumber++;
                              //Add database here
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
                  ],
                ),
              ],
            )),
      ],
    );

    MultiSplitView checkoutSplitView = MultiSplitView(
        controller: _checkoutMvController,
        children: [checkoutInfo, orderSummary]);

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
