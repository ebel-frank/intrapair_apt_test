import 'package:azlistview/azlistview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intrapair_mobile_apt_test/data/api.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();

  late List<_AZItem> _searchCountries;
  List<Map>? _countries;

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  Future<void> getCountries() async {
    final countries = await CountryAPI().getCountries();
    // reload the page
    setState(() {
      _searchCountries = formatCountries(countries);
      _countries = countries;
    });
  }

  List<_AZItem> formatCountries(List<Map> countries) {
    // format the countries to be used in the AzListView
    final fmtCountries = countries
        .map((country) => _AZItem(
            id: country['id'],
            name: country['name'],
            flag: country['flag'],
            tag: country['name'][0].toString().toUpperCase()))
        .toList();
    SuspensionUtil.sortListBySuspensionTag(fmtCountries);
    return fmtCountries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Select Country',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search Country',
                hintStyle: TextStyle(color: CupertinoColors.inactiveGray),
                prefixIcon:
                    Icon(Icons.search, color: CupertinoColors.inactiveGray),
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: CupertinoColors.inactiveGray),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: CupertinoColors.inactiveGray),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
              ),
              onChanged: (text) {
                final searchCountries = (text.isEmpty
                        ? _countries
                        : [
                            ...?_countries?.where((country) => country['name']
                                .toLowerCase()
                                .contains(text.toLowerCase()))
                          ]) ??
                    [];
                setState(() {
                  _searchCountries = formatCountries(searchCountries);
                });
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: _countries == null
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeCap: StrokeCap.round,
                    ),
                  )
                : _searchCountries.isEmpty
                    ? const Center(
                        child: Text("Sorry, no countries found."),
                      )
                    : AzListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        data: _searchCountries,
                        itemCount: _searchCountries.length,
                        itemBuilder: (context, index) {
                          final country = _searchCountries[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context, {
                                'id': country.id,
                                'name': country.name,
                                'flag': country.flag,
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                _searchCountries[index]
                                                    .flag
                                                    .toString()))),
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                      child: Text(_searchCountries[index]
                                          .name
                                          .toString()))
                                ],
                              ),
                            ),
                          );
                        },
                        indexBarOptions: IndexBarOptions(
                            indexHintAlignment: Alignment.centerRight,
                            indexHintWidth: 50,
                            indexHintHeight: 50,
                            textStyle: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey),
                            selectItemDecoration: const BoxDecoration(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            selectTextStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold),
                            needRebuild: true,
                            indexHintDecoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            )),
                indexBarMargin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
          )
        ],
      )),
    );
  }
}

class _AZItem extends ISuspensionBean {
  final int id;
  final String name;
  final String flag;
  final String tag;

  _AZItem(
      {required this.id,
      required this.name,
      required this.flag,
      required this.tag});

  @override
  String getSuspensionTag() => tag;
}
