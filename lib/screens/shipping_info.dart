

import 'package:byminuser/Widgets/localization_strings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:toast/toast.dart';

import '../custom/toast_component.dart';
import '../data_model/city_response.dart';
import '../data_model/country_response.dart';
import '../helpers/shared_value_helper.dart';
import '../helpers/shimmer_helper.dart';
import '../my_theme.dart';
import '../repositories/address_repositories.dart';
import 'checkout.dart';

class ShippingInfo extends StatefulWidget {
  int? owner_id;

  ShippingInfo({Key? key, this.owner_id}) : super(key: key);

  @override
  _ShippingInfoState createState() => _ShippingInfoState();
}

class _ShippingInfoState extends State<ShippingInfo> {
  ScrollController _mainScrollController = ScrollController();

  int _seleted_shipping_address = 0;
  late City _selected_city;

  late Country _selected_country;

  bool _isInitial = true;
  List<dynamic> _shippingAddressList = [];
  List<City> _cityList = [];
  List<Country> _countryList = [];
  String _selected_city_name = "";
  String _selected_country_name = "";

  String _selected_address_city_name = "";
  String _shipping_cost_string = ". . .";

  Country getCountryById(String id) =>
      _countryList.firstWhere((country) => country.id == id);

  Country getCountryByPartialName(String partial_name) =>
      _countryList.firstWhere((country) => country.name == partial_name);

  List<Country> getCountriesByPartialName(String partial_name) =>
      _countryList.where((country) => country.name == partial_name).toList();

  City getCityById(String id) => _cityList.firstWhere((city) => city.id == id);

  City getCityByPartialName(String partial_name) =>
      _cityList.firstWhere((city) => city.name == partial_name);

  List<City> getCitiesByPartialName(String partial_name) =>
      _cityList.where((city) => city.name == partial_name).toList();

  //controllers
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*print("user data");
    print(is_logged_in.$);
    print(access_token.$);
    print(user_id.$);
    print(user_name.$);*/

    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  fetchAll() {
    if (is_logged_in.$ == true) {
      fetchShippingAddressList();
    }
    fetchCityList();
    fetchCountryList();
    _isInitial = false;
    setState(() {});
  }

  fetchShippingAddressList() async {
    var addressResponse = await AddressRepository().getAddressList();
    _shippingAddressList.addAll(addressResponse.addresses!);
    if (_shippingAddressList.length > 0) {
      _seleted_shipping_address = _shippingAddressList[0].id;

      _shippingAddressList.forEach((address) {
        if (address.set_default == 1) {
          _seleted_shipping_address = address.id;
          _selected_address_city_name = address.city;
        }
      });
    }
    setState(() {});

    getSetShippingCost();
  }

  getSetShippingCost() async {
    var shippingCostResponse = await AddressRepository()
        .getShippingCostResponse(
            widget.owner_id!, user_id.$, _selected_address_city_name);

    if (shippingCostResponse.result == true) {
      _shipping_cost_string = shippingCostResponse.value_string!;
      setState(() {});
    }
  }

  fetchCityList() async {
    var cityResponse = await AddressRepository().getCityList();

    _cityList.addAll(cityResponse.cities!);
    setState(() {});
  }

  fetchCountryList() async {
    var countryResponse = await AddressRepository().getCountryList();

    _countryList.addAll(countryResponse.countries!);
    setState(() {});
  }

  reset() {
    _shippingAddressList.clear();
    _cityList.clear();
    _countryList.clear();
    _selected_city_name = "";
    _selected_country_name = "";
    _shipping_cost_string = ". . .";
    _shipping_cost_string = ". . .";
    _isInitial = true;
  }

  Future<void> _onRefresh() async {
    reset();
    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  onPopped(value) async {
    // reset();
    // fetchAll();
  }

  afterAddingAnAddress() {
    reset();
    fetchAll();
  }

  onAddressSwitch() async {
    _shipping_cost_string = ". . .";
    setState(() {});
    getSetShippingCost();
  }

  onAddressAdd(context) async {
    var address = _addressController.text.toString();
    var postal_code = _postalCodeController.text.toString();
    var phone = _phoneController.text.toString();

    if (address == "") {
      ToastComponent.showDialog("Enter Address", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (_selected_city_name == "") {
      ToastComponent.showDialog("Select a city", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (_selected_country_name == "") {
      ToastComponent.showDialog("Select a country", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var addressAddResponse = await AddressRepository().getAddressAddResponse(
        address,
        _selected_country_name,
        _selected_city_name,
        postal_code,
        phone);

    if (addressAddResponse.result == false) {
      ToastComponent.showDialog(addressAddResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    ToastComponent.showDialog(addressAddResponse.message.toString(), context,
        gravity: Toast.center, duration: Toast.lengthLong);

    Navigator.of(context).pop();
    reset();
    fetchAll();
  }

  onPressProceed(context) async {
    if (_seleted_shipping_address == 0) {
      ToastComponent.showDialog("Select a country", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var addressUpdateInCartResponse = await AddressRepository()
        .getAddressUpdateInCartResponse(_seleted_shipping_address);

    if (addressUpdateInCartResponse.result == false) {
      ToastComponent.showDialog(addressUpdateInCartResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    ToastComponent.showDialog(addressUpdateInCartResponse.message.toString(), context,
        gravity: Toast.center, duration: Toast.lengthLong);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Checkout(
        owner_id: widget.owner_id,
      );
    })).then((value) {
      onPopped(value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mainScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        bottomNavigationBar: buildBottomAppBar(context),
        body: RefreshIndicator(
          color: MyTheme.accent_color,
          backgroundColor: Colors.white,
          onRefresh: _onRefresh,
          displacement: 0,
          child: CustomScrollView(
            controller: _mainScrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: buildShippingInfoList(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    // minWidth: MediaQuery.of(context).size.width - 16,
                    // height: 60,
                    // color: Color.fromRGBO(252, 252, 252, 1),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(8.0),
                    //     side:
                    //         BorderSide(color: MyTheme.light_grey, width: 1.0)),
                    child: Icon(
                      Icons.plus_one,
                      color: MyTheme.dark_grey,
                      size: 16,
                    ),
                    onPressed: () {
                      buildShowAddFormDialog(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 100,
                )
              ]))
            ],
          ),
        ));
  }

  Future buildShowAddFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              contentPadding: EdgeInsets.only(
                  top: 36.0, left: 36.0, right: 36.0, bottom: 2.0),
              content: Container(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(LocalizationString.addr,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 55,
                          child: TextField(
                            controller: _addressController,
                            autofocus: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                hintText: "Enter Address",
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(
                                    left: 8.0, top: 16.0, bottom: 16.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(LocalizationString.cit,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      /*Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: "Enter City",
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(left: 8.0)),
                          ),
                        ),
                      ),*/

                      // Dropdown Search

                      /*Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child:
                          DropdownSearch<City>(
                            items: _cityList,
                            maxHeight: 300,
                            label: "Select a city",
                            showSearchBox: true,
                            selectedItem: _selected_city,
                            dropdownSearchDecoration: InputDecoration(
                                hintText: "Enter City",
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(left: 8.0)),
                            onChanged: (City city) {
                              setState(() {
                                _selected_city = city;
                                _selected_city_name = city.name;
                              });
                            },
                          ),
                        ),
                      ),*/
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(LocalizationString.postal,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _postalCodeController,
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: "Enter Postal Code",
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(left: 8.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(LocalizationString.country,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),

                      // DropDownSearch

                     /* Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: DropdownSearch<Country>(
                            items: _countryList,
                            maxHeight: 300,
                            label: "Select a country",
                            showSearchBox: true,
                            selectedItem: _selected_country,
                            dropdownSearchDecoration: InputDecoration(
                                hintText: "Enter Postal Code",
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(left: 8.0)),
                            onChanged: (Country country) {
                              setState(() {
                                _selected_country = country;
                                _selected_country_name = country.name;
                              });
                            },
                          ),
                        ),
                      ),*/
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(LocalizationString.phone,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          height: 40,
                          child: TextField(
                            controller: _phoneController,
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: "Enter Phone",
                                hintStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: MyTheme.textfield_grey),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 0.5),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyTheme.textfield_grey,
                                      width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(8.0),
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(left: 8.0)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        // minWidth: 75,
                        // height: 30,
                        // color: Color.fromRGBO(253, 253, 253, 1),
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(8.0),
                        //     side: BorderSide(
                        //         color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          LocalizationString.close,
                          style: TextStyle(
                            color: MyTheme.font_grey,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: ElevatedButton(
                        // minWidth: 75,
                        // height: 30,
                        // color: MyTheme.accent_color,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(8.0),
                        //     side: BorderSide(
                        //         color: MyTheme.light_grey, width: 1.0)),
                        child: Text(
                          LocalizationString.add,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onAddressAdd(context);
                        },
                      ),
                    )
                  ],
                )
              ],
            ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "Shipping Cost ${_shipping_cost_string}",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildShippingInfoList() {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                LocalizationString.pleaselog,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else if (_isInitial && _shippingAddressList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (_shippingAddressList.length > 0) {
      return SingleChildScrollView(
        child: ListView.builder(
          itemCount: _shippingAddressList.length,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: buildShippingInfoItemCard(index),
            );
          },
        ),
      );
    } else if (!_isInitial && _shippingAddressList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
                LocalizationString.noaddress,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    }
  }

  GestureDetector buildShippingInfoItemCard(index) {
    return GestureDetector(
      onTap: () {
        if (_seleted_shipping_address != _shippingAddressList[index].id) {
          setState(() {
            _seleted_shipping_address = _shippingAddressList[index].id;
            _selected_address_city_name = _shippingAddressList[index].city;
          });
          onAddressSwitch();
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _seleted_shipping_address == _shippingAddressList[index].id
              ? BorderSide(color: MyTheme.accent_color, width: 2.0)
              : BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        LocalizationString.addr,
                        style: TextStyle(
                          color: MyTheme.grey_153,
                        ),
                      ),
                    ),
                    Container(
                      width: 175,
                      child: Text(
                        _shippingAddressList[index].address,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Spacer(),
                    buildShippingOptionsCheckContainer(
                        _seleted_shipping_address ==
                            _shippingAddressList[index].id)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        LocalizationString.cit,
                        style: TextStyle(
                          color: MyTheme.grey_153,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].city,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        LocalizationString.postal,
                        style: TextStyle(
                          color: MyTheme.grey_153,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].postal_code,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        "Country",
                        style: TextStyle(
                          color: MyTheme.grey_153,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].country,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 75,
                      child: Text(
                        LocalizationString.phone,
                        style: TextStyle(
                          color: MyTheme.grey_153,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      child: Text(
                        _shippingAddressList[index].phone,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.dark_grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildShippingOptionsCheckContainer(bool check) {
    return check
        ? Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), color: Colors.green),
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(Icons.check, color: Colors.white, size: 10),
            ),
          )
        : Container();
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              // minWidth: MediaQuery.of(context).size.width,
              // height: 50,
              // color: MyTheme.accent_color,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(0.0),
              // ),
              child: Text(
                LocalizationString.proceCheck,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                onPressProceed(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
