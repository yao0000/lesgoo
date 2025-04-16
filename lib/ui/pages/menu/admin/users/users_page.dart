import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/constants/app_colors.dart';
import 'package:travel/data/models/index.dart';
import 'package:travel/data/repositories/user_repository.dart';
import 'package:travel/ui/widgets/container_no_data.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UsersPage> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> list = [];
  List<UserModel> fetchList = [];
  List<String> searchHistory = [];

  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _loadSearchHistory();
  }

  Future<void> _loadUsers() async {
    List<UserModel> tempList = await UserRepository.getList();
    setState(() {
      fetchList = tempList;
      list = tempList;
    });
  }

  Future<void> _loadSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      searchHistory = prefs.getStringList("users") ?? [];
    });
  }

  Future<void> saveSearchHistory(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!searchHistory.contains(query)) {
      searchHistory.insert(0, query);
      if (searchHistory.length > 10) {
        searchHistory = searchHistory.sublist(0, 10);
      }
      await prefs.setStringList("users", searchHistory);
    }
  }

  void saveSearchHistoryToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('searchHistory', searchHistory);
  }

  void search() {
    String query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        list = fetchList;
      });
      return;
    }
    setState(() {
      list = fetchList;

      list =
          list
              .where(
                (item) => item.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    });
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
      child: Scaffold(
        backgroundColor: AppColors.adminBg,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Users"),
          backgroundColor: AppColors.adminBg,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
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
                            search();
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
                            hintText: 'Search user...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      list.isEmpty
                          ? noDataScreen("No users found")
                          : ListView.builder(
                            itemCount: list.length,
                            itemBuilder:
                                (context, index) => _buildUserCard(list[index]),
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
                            search();
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

  Widget _buildUserCard(UserModel user) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: () async {
          bool? isDeleted = await context.push('/userDetail', extra: user.uid);
          if (isDeleted == true) {
            _loadUsers();
          }
        },
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child:
              (user.imageUrl.isEmpty)
                  ? Image.asset(
                    "assets/img/me.png",
                    width: 25,
                    height: 25,
                    color: AppColors.navyBlue,
                  )
                  : ClipOval(
                    child: Image.network(
                      user.imageUrl,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
        ),
        title: Text(
          user.name.isEmpty ? "Undefined" : user.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: user.name.isEmpty ? Colors.red : AppColors.navyBlue,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text("Email: ${user.email}"), Text("Role: ${user.role}")],
        ),
      ),
    );
  }
}
