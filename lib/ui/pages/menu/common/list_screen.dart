import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travel/data/global.dart';
import 'package:travel/data/repositories/car_repository.dart';
import 'package:travel/data/repositories/hotel_repository.dart';
import 'package:travel/data/repositories/restaurant_repository.dart';
import 'package:travel/ui/pages/menu/common/filter_drawer.dart';
import 'package:travel/ui/widgets/button_action.dart';
import 'package:travel/ui/widgets/card_object.dart';

class ListScreen extends StatefulWidget {
  final String type;

  const ListScreen({super.key, required this.type});

  @override
  State<StatefulWidget> createState() => _ListScreen();
}

class _ListScreen extends State<ListScreen> {
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

  List<dynamic>? list = [];
  List<dynamic>? fetchList = [];
  List<String> sortOption = [];

  @override
  void initState() {
    super.initState();
    loadList();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => openFilterDrawer(context),
          ),
        ],
      ),
      backgroundColor: Colors.blue[100],
      body: Column(
        children: [
          Expanded(
            child:
                list == null
                    ? const Center(child: CircularProgressIndicator())
                    : list!.isEmpty
                    ? const Center(child: Text("No data available"))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: list!.length,
                      itemBuilder: (context, index) {
                        return CardObject(item: list![index]);
                      },
                    ),
          ),
          if (Global.user.role == 'admin')
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ButtonAction(
                label:
                    "Add New ${widget.type.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '').join(' ')}",
                onPressed:
                    () => GoRouter.of(context).push('/itemAdd/${widget.type}'),
              ),
            ),
        ],
      ),
    );
  }
}
