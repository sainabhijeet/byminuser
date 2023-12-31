

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:toast/toast.dart';

import '../Widgets/localization_strings.dart';
import '../custom/toast_component.dart';
import '../data_model/city_response.dart';
import '../data_model/country_response.dart';
import '../helpers/shared_value_helper.dart';
import '../helpers/shimmer_helper.dart';
import '../my_theme.dart';
import '../repositories/address_repositories.dart';

class Address extends StatefulWidget {
  Address({Key? key}) : super(key: key);

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  ScrollController _mainScrollController = ScrollController();

  int _default_shipping_address = 0;
  City? _selected_city;
  Country? _selected_country;

  bool _isInitial = true;
  List<dynamic> _shippingAddressList = [];
  List<City> _cityList = [];
  List<Country> _countryList = [];
  String _selected_city_name = "";
  String _selected_country_name = "";

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

  //controllers for add purpose
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  //for update purpose
  List<TextEditingController> _addressControllerListForUpdate = [];
  List<TextEditingController> _postalCodeControllerListForUpdate = [];
  List<TextEditingController> _phoneControllerListForUpdate = [];
  List<String> _selected_city_name_list_for_update = [];
  List<String> _selected_country_name_list_for_update = [];
  List<City> _selected_city_list_for_update = [];
  List<Country> _selected_country_list_for_update = [];

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
    fetchCityList();
    fetchCountryList();
    if (is_logged_in.$ == true) {
      fetchShippingAddressList();
    }
    _isInitial = false;
    setState(() {});
  }

  fetchShippingAddressList() async {
    var addressResponse = await AddressRepository().getAddressList();
    _shippingAddressList.addAll(addressResponse.addresses!.toList());
    if (_shippingAddressList.length > 0) {
      //_default_shipping_address = _shippingAddressList[0].id;

      _shippingAddressList.forEach((address) {
        if (address.set_default == 1) {
          _default_shipping_address = address.id;
        }
        _addressControllerListForUpdate
            .add(TextEditingController(text: address.address));
        _postalCodeControllerListForUpdate
            .add(TextEditingController(text: address.postal_code));
        _phoneControllerListForUpdate
            .add(TextEditingController(text: address.phone));
        _selected_city_name_list_for_update.add(address.city);
        _selected_city_list_for_update.add(getCityByPartialName(address.city));
        _selected_country_name_list_for_update.add(address.country);
        _selected_country_list_for_update
            .add(getCountryByPartialName(address.country));
      });
    }
    setState(() {});
  }

  fetchCityList() async {
    var cityResponse = await AddressRepository().getCityList();

    _cityList.addAll(cityResponse.cities!.toList());
    setState(() {});
  }

  fetchCountryList() async {
    var countryResponse = await AddressRepository().getCountryList();

    _countryList.addAll(countryResponse.countries!.toList());
    setState(() {});
  }

  reset() {
    _shippingAddressList.clear();
    _cityList.clear();
    _countryList.clear();
    _selected_city_name = "";
    _selected_country_name = "";
    _isInitial = true;

    //update-ables
    _addressControllerListForUpdate.clear();
    _postalCodeControllerListForUpdate.clear();
    _phoneControllerListForUpdate.clear();
    _selected_city_name_list_for_update.clear();
    _selected_country_name_list_for_update.clear();
    _selected_city_list_for_update.clear();
    _selected_country_list_for_update.clear();
    setState(() {});
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

  afterDeletingAnAddress() {
    reset();
    fetchAll();
  }

  afterUpdatingAnAddress() {
    reset();
    fetchAll();
  }

  onAddressSwitch(index) async {
    var addressMakeDefaultResponse = await AddressRepository()
        .getAddressMakeDefaultResponse(_default_shipping_address);

    if (addressMakeDefaultResponse.result == false) {
      ToastComponent.showDialog(addressMakeDefaultResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    ToastComponent.showDialog(addressMakeDefaultResponse.message.toString(), context,
        gravity: Toast.center, duration: Toast.lengthLong);

    setState(() {
      _default_shipping_address = _shippingAddressList[index].id;
    });
  }

  onPressDelete(id) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: EdgeInsets.only(
                  top: 16.0, left: 2.0, right: 2.0, bottom: 2.0),
              content: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                  LocalizationString.areyou,
                  maxLines: 3,
                  style: TextStyle(color: MyTheme.font_grey, fontSize: 14),
                ),
              ),
              actions: [
                ElevatedButton(
                  child: Text(
                    LocalizationString.cancel,
                    style: TextStyle(color: MyTheme.medium_grey),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              // FlatButton(
              //   color: MyTheme.soft_accent_color,
              //   child: Text(
              //     "Confirm",
              //     style: TextStyle(color: MyTheme.dark_grey),
              //   ),
              //   onPressed: () {
              //     Navigator.pop(context);
              //     confirmDelete(id);
              //   },
              // ),
            ));
  }

  confirmDelete(id) async {
    var addressDeleteResponse =
        await AddressRepository().getAddressDeleteResponse(id);

    if (addressDeleteResponse.result == false) {
      ToastComponent.showDialog(addressDeleteResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    ToastComponent.showDialog(addressDeleteResponse.message.toString(), context,
        gravity: Toast.center, duration: Toast.lengthLong);

    afterDeletingAnAddress();
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
    afterAddingAnAddress();
  }

  onAddressUpdate(context, index, id) async {
    var address = _addressControllerListForUpdate[index].text.toString();
    var postal_code = _postalCodeControllerListForUpdate[index].text.toString();
    var phone = _phoneControllerListForUpdate[index].text.toString();

    /*print('trial');
    print(_addressControllerListForUpdate.length);
    return;*/

    if (address == "") {
      ToastComponent.showDialog("Enter Address", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (_selected_city_name_list_for_update[index] == "") {
      ToastComponent.showDialog("Select a city", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    if (_selected_country_name_list_for_update[index] == "") {
      ToastComponent.showDialog("Select a country", context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    var addressUpdateResponse = await AddressRepository()
        .getAddressUpdateResponse(
            id,
            address,
            _selected_country_name_list_for_update[index],
            _selected_city_name_list_for_update[index],
            postal_code,
            phone);

    if (addressUpdateResponse.result == false) {
      ToastComponent.showDialog(addressUpdateResponse.message.toString(), context,
          gravity: Toast.center, duration: Toast.lengthLong);
      return;
    }

    ToastComponent.showDialog(addressUpdateResponse.message.toString(), context,
        gravity: Toast.center, duration: Toast.lengthLong);

    Navigator.of(context).pop();
    afterUpdatingAnAddress();
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
                  child: buildAddressList(),
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
                      Icons.hls,
                      color: MyTheme.dark_grey,
                      size: 16,
                    ),
                    onPressed: () {
                      buildShowAddFormDialog(context);
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: FlatButton(
                //     minWidth: MediaQuery.of(context).size.width - 16,
                //     height: 60,
                //     color: Color.fromRGBO(252, 252, 252, 1),
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8.0),
                //         side:
                //             BorderSide(color: MyTheme.light_grey, width: 1.0)),
                //     child: Icon(
                //       FontAwesome.plus,
                //       color: MyTheme.dark_grey,
                //       size: 16,
                //     ),
                //     onPressed: () {
                //       buildShowAddFormDialog(context);
                //     },
                //   ),
                // ),
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
                        child: Text("Address *",
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
                        child: Text(LocalizationString.city,
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

                      // DropDownSearch

                     /* Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: DropdownSearch<City>(
                            items: _cityList,
                            maxHeight: 300,
                            label: "Select a city",
                            showSearchBox: true,
                            selectedItem: _selected_city,
                            dropdownSearchDecoration: InputDecoration(
                                hintText: "Enter City",
                                hintStyle: TextStyle(
                                    fontSize: 11.0,
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
                                _selected_city_name = city.name!;
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
                                _selected_country_name = country.name!;
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

  Future buildShowUpdateFormDialog(BuildContext context, index) {
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
                        child: Text(LocalizationString.address,
                            style: TextStyle(
                                color: MyTheme.font_grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 55,
                          child: TextField(
                            controller: _addressControllerListForUpdate[index],
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
                        child: Text(LocalizationString.city,
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

                      // DropDownSearch

                     /* Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: DropdownSearch<City>(
                            items: _cityList,
                            maxHeight: 300,
                            label: "Select a city",
                            showSearchBox: true,
                            selectedItem: _selected_city_list_for_update[index],
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
                                _selected_city_list_for_update[index] = city;
                                _selected_city_name_list_for_update[index] =
                                    city.name!;
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
                            controller:
                                _postalCodeControllerListForUpdate[index],
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

                      /*Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          height: 40,
                          child: DropdownSearch<Country>(
                            items: _countryList,
                            maxHeight: 300,
                            label: "Select a country",
                            showSearchBox: true,
                            selectedItem:
                                _selected_country_list_for_update[index],
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
                                _selected_country_list_for_update[index] =
                                    country;
                                _selected_country_name_list_for_update[index] =
                                    country.name!;
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
                            controller: _phoneControllerListForUpdate[index],
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
                          "UPDATE",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          onAddressUpdate(
                              context, index, _shippingAddressList[index].id);
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
      title: Column(
        children: [
          Text(
            LocalizationString.addressuser,
            style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
          ),
          Text(
            LocalizationString.doubletap,
            style: TextStyle(fontSize: 10, color: MyTheme.medium_grey),
          ),
        ],
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildAddressList() {
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
              child: buildAddressItemCard(index),
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

  GestureDetector buildAddressItemCard(index) {
    return GestureDetector(
      onDoubleTap: () {
        if (_default_shipping_address != _shippingAddressList[index].id) {
          onAddressSwitch(index);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: _default_shipping_address == _shippingAddressList[index].id
              ? BorderSide(color: MyTheme.accent_color, width: 2.0)
              : BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        child: Stack(
          children: [
            Padding(
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
                            LocalizationString.count,
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
            Positioned(
                right: 0.0,
                top: 0.0,
                child: InkWell(
                  onTap: () {
                    buildShowUpdateFormDialog(context, index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16.0, left: 16.0, right: 16.0, bottom: 12.0),
                    child: Icon(
                      Icons.edit,
                      color: MyTheme.dark_grey,
                      size: 16,
                    ),
                  ),
                )),
            Positioned(
                right: 0,
                top: 40.0,
                child: InkWell(
                  onTap: () {
                    onPressDelete(_shippingAddressList[index].id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12.0, left: 16.0, right: 16.0, bottom: 16.0),
                    child: Icon(
                      Icons.delete_forever_outlined,
                      color: MyTheme.dark_grey,
                      size: 16,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
