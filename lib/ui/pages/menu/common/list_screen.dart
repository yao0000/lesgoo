import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/global.dart';
import 'package:travel/data/repositories/car_repository.dart';
import 'package:travel/data/repositories/hotel_repository.dart';
import 'package:travel/data/repositories/restaurant_repository.dart';
import 'package:travel/ui/pages/menu/common/filter_drawer.dart';
import 'package:travel/ui/widgets/card_object.dart';
import 'package:travel/ui/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListScreen extends StatefulWidget {
  final String type;
  final int mode;
  // mode = 0 > user & admin list screen
  // mode = 1 > admin track
  const ListScreen({super.key, required this.type, required this.mode});

  @override
  State<StatefulWidget> createState() => _ListScreen();
}

class _ListScreen extends State<ListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic>? list = [];
  List<dynamic>? fetchList = [];
  List<String> sortOption = [];
  List<String> searchHistory = [];

  bool showDropdown = false;

  Map<String, bool> filterState = {
    'desc': false,
    'asc': false,
    '5': false,
    '4': false,
    '3': false,
    '2': false,
  };

  void toggleFilterState(String key) {
    setState(() {
      filterState[key] = !filterState[key]!;
      sortList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadList();
    loadSearchHistory();
  }

  void updateFilterOption(List<String> options) {
    setState(() {
      sortOption = options;
      sortList();
      Navigator.pop(context);
    });
  }

  void openFilterDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FilterDrawer(
          toggleState: toggleFilterState,
          filterState: filterState,
        );
      },
    );
  }

  void loadList() async {
    fetchList = await getFutureList();
    setState(() {
      list = fetchList;
      sortList();
    });
  }

  Future<List<dynamic>?> getFutureList() {
    switch (widget.type) {
      case "hotels":
        return HotelRepository.getList();
      case "cars":
        return CarRepository.getList();
      default:
        return RestaurantRepository.getList();
    }
  }

  void sortList() {
    setState(() {
      list = fetchList;

      if (filterState['desc'] == true && filterState['asc'] == false) {
        list!.sort((a, b) => b.price.compareTo(a.price));
      } else if (filterState['desc'] == false && filterState['asc'] == true) {
        list!.sort((a, b) => a.price.compareTo(b.price));
      }

      list =
          (list == null || list!.isEmpty)
              ? []
              : list!
                  .where(
                    (item) =>
                        (filterState['5'] == true && item.rating == 5.0) ||
                        (filterState['4'] == true &&
                            (item.rating >= 4.0 && item.rating < 5.0)) ||
                        (filterState['3'] == true &&
                            (item.rating >= 3.0 && item.rating < 4.0)) ||
                        (filterState['2'] == true && item.rating < 3.0) ||
                        (filterState['5'] == false &&
                            filterState['4'] == false &&
                            filterState['3'] == false &&
                            filterState['2'] == false),
                  )
                  .toList();
    });

    if (_searchController.text.trim().isNotEmpty) {
      String query = _searchController.text.trim();
      list =
          list!
              .where(
                (item) =>
                    item.name.toLowerCase().contains(query.toLowerCase()) ||
                    item.address.toLowerCase().contains(query.toLowerCase()) ||
                    (widget.type == "restaurants" &&
                        item.cuisine.toLowerCase().contains(
                          query.toLowerCase(),
                        )),
              )
              .toList();
    }
  }

  Future<void> loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList(widget.type) ?? [];
    });
  }

  Future<void> saveSearchHistory(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!searchHistory.contains(query)) {
      searchHistory.insert(0, query);
      if (searchHistory.length > 10) {
        searchHistory = searchHistory.sublist(0, 10);
      }
      await prefs.setStringList(widget.type, searchHistory);
    }
  }

  void saveSearchHistoryToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('searchHistory', searchHistory);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showDropdown = false; // Hide dropdown when tapping outside
        });
        FocusScope.of(context).unfocus(); // Close keyboard if open
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.type.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Global.user.role == "admin" ? AppColors.adminBg : AppColors.bgColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        backgroundColor: Global.user.role == "admin" ? AppColors.adminBg : Colors.blue[100],
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  sortList();
                                },
                                onTap: () {
                                  if (searchHistory.isEmpty) {
                                    return;
                                  }
                                  setState(() {
                                    showDropdown = true;
                                  });
                                },
                                onSubmitted: (value) {
                                  saveSearchHistory(value);
                                  setState(() {
                                    showDropdown = false;
                                  });
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Search by name & location...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.filter_list,
                                color: Colors.grey,
                              ),
                              onPressed: () => openFilterDrawer(context),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      list == null
                          ? const Center(child: CircularProgressIndicator())
                          : list!.isEmpty
                          ? noDataScreen("No data available")
                          : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: list!.length,
                            itemBuilder: (context, index) {
                              return CardObject(
                                item: list![index],
                                isDetail: widget.mode == 0,
                              );
                            },
                          ),
                ),
                if (Global.user.role == 'admin' && widget.mode == 0)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ButtonAction(
                      label:
                          "Add New ${widget.type.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '').join(' ')}",
                      onPressed: () async {
                        bool? isAddedNew = await GoRouter.of(
                          context,
                        ).push('/itemAdd/${widget.type}');
                        if (isAddedNew == true) {
                          loadList();
                        }
                      },
                    ),
                  ),
              ],
            ),
            if (showDropdown && searchHistory.isNotEmpty)
              Positioned(
                left: 16,
                right: 16,
                top: 70,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: searchHistory.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(searchHistory[index]),
                          leading: Icon(Icons.history, color: Colors.grey),
                          trailing: IconButton(
                            icon: Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                searchHistory.removeAt(
                                  index,
                                ); // Remove item from the list
                              });
                              saveSearchHistoryToStorage(); // Update storage
                            },
                          ),
                          onTap: () {
                            _searchController.text = searchHistory[index];
                            sortList();
                            setState(() {
                              showDropdown = false;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
