import 'package:bookmark_app/src/core/constants/colors.dart';
import 'package:bookmark_app/src/core/constants/text_styles.dart';
import 'package:bookmark_app/src/feature/search/presentation/widgets/add_button.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Map<String, dynamic>> items = [
    {
      'id': 1,
      'image': 'assets/images/apple.png',
      'title': 'Яблоко красная радуга сладкая',
      'price': '112',
      'category': 'Фрукты'
    },
    {
      'id': 2,
      'image': 'assets/images/apelsin.png',
      'title': 'Апельсины сладкий пакистанский',
      'price': '100',
      'category': 'Фрукты'
    },
    {
      "id": 3,
      'image': 'assets/images/dragon.png',
      'title': 'Драконий фрукт',
      'price': '130',
      'category': 'Сухофрукты'
    }
  ];
  final List<Map<String, dynamic>> kategories = [
    {'title': 'Все'},
    {'title': 'Фрукты'},
    {'title': 'Сухофрукты'},
    {'title': 'Овощи'}
  ];

  List<Map<String, dynamic>> filteredfruits = [];

  Map<int, int> quantities = {};

  String selectedCategories = 'Все';

  @override
  void initState() {
    super.initState();
    filteredfruits = items; // Изначально показываем все элементы
  }

  void fruitsByCategory(String category) {
    selectedCategories = category;
    setState(() {
      if (category == 'Все') {
        // Если строка для поиска пуста, показываем все элементы
        filteredfruits = items;
      } else {
        // Фильтруем элементы, если их title содержит введенный запрос (регистронезависимо)
        filteredfruits = items.where((item) {
          return item['category']
              .toString()
              .toLowerCase()
              .contains(category.toLowerCase());
        }).toList();
      }
    });
  }

  void filterFruits(String letter) {
    setState(() {
      if (letter.isEmpty) {
        // Если строка для поиска пуста, показываем все элементы
        filteredfruits = items;
      } else {
        // Фильтруем элементы, если их title содержит введенный запрос (регистронезависимо)
        filteredfruits = items.where((item) {
          return item['title']
              .toString()
              .toLowerCase()
              .contains(letter.toLowerCase());
        }).toList();
      }
    });
  }

  void incrementQuantity(int id) {
    setState(() {
      quantities[id] = (quantities[id] ?? 0) + 1;
    });
  }

  void decrementQuantity(int id) {
    setState(() {
      if (quantities[id] != null && quantities[id]! > 0) {
        quantities[id] = quantities[id]! - 1;
      }
    });
  }

  double getTotalPrice() {
    double total = 0;
    for (var product in items) {
      final id = product['id'];
      final quantity = quantities[id] ?? 0;
      final price = double.tryParse(product['price']) ?? 0;
      total += quantity * price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: const _GestureDetector(),
        title: Text('Продукты',
            style: AppTextStyles.f18w500.copyWith(color: AppColors.blackText)),
        centerTitle: true,
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
        child: Column(
          children: [
            _TextField(
              onChanged: (letter) {
                filterFruits(letter);
              },
            ),
            const SizedBox(
              height: 12,
            ),
            _ListView(
                kategories: kategories,
                onTap: (category) {
                  fruitsByCategory(category);
                },
                selectedCategories: selectedCategories),
            const SizedBox(
              height: 20,
            ),
            _GridView(
              items: filteredfruits,
              quantities: quantities,
              onIncrement: (id) => incrementQuantity(id),
              onDecrement: (id) => decrementQuantity(id),
            ),
          ],
        ),
      ),
      floatingActionButton: _BagButton(
        totalPrice: getTotalPrice(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _GestureDetector extends StatelessWidget {
  const _GestureDetector();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: const Icon(
        Icons.chevron_left,
        color: AppColors.black,
        size: 24,
      ),
    );
  }
}

class _BagButton extends StatelessWidget {
  double totalPrice;
  _BagButton({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 50,
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset('assets/images/bag.png', width: 24, height: 24),
            Text(
              'Корзина',
              style: AppTextStyles.f16w500.copyWith(color: AppColors.white),
            ),
            Text(
              '${totalPrice.toString()} с',
              style: AppTextStyles.f16w500.copyWith(color: AppColors.white),
            )
          ],
        ),
      ),
    );
  }
}

class _GridView extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Map<int, int> quantities;
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  const _GridView({
    required this.items,
    required this.quantities,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/images/freebag.png'),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Ничего не нашли!!!',
            style: AppTextStyles.f18w600.copyWith(color: AppColors.greyText),
          ),
        ],
      );
    }
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 240,
            mainAxisSpacing: 11,
            crossAxisSpacing: 11),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final id = item['id'];
          final quantity = quantities[id] ?? 0;

          return GestureDetector(
            onTap: () {},
            child: SizedBox(
              height: 228,
              width: 166,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        items[index]['image'],
                        width: 158,
                        height: 96,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${items[index]['title']}',
                        style: AppTextStyles.f14w500
                            .copyWith(color: AppColors.blackText),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Text(
                            '${items[index]['price']}',
                            style: AppTextStyles.f20w700
                                .copyWith(color: AppColors.green),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'с',
                            style: AppTextStyles.f14w700
                                .copyWith(color: AppColors.green),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      quantity == 0
                          ? AddButton(
                              onPressed: () => onIncrement(id),
                              text: 'Добавить')
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.green,
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: const Icon(
                                      Icons.remove,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  onPressed: () => onDecrement(id),
                                ),
                                Text(
                                  '$quantity',
                                  style: AppTextStyles.f16w500
                                      .copyWith(color: AppColors.blackText),
                                ),
                                IconButton(
                                  icon: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.green,
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: const Icon(Icons.add,
                                        color: AppColors.white),
                                  ),
                                  onPressed: () => onIncrement(id),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ListView extends StatelessWidget {
  final List<Map<String, dynamic>> kategories;
  final Function(String) onTap;
  final String selectedCategories;
  const _ListView(
      {required this.kategories,
      required this.onTap,
      required this.selectedCategories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          bool isSelected = kategories[index]['title'] == selectedCategories;

          return GestureDetector(
            onTap: () {
              onTap(kategories[index]['title']);
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  30,
                ),
                border: Border.all(
                    color: isSelected ? AppColors.green : AppColors.grey,
                    width: 1.0),
                color: isSelected ? AppColors.green : AppColors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Center(
                  child: Text(
                    '${kategories[index]['title']}',
                    style: AppTextStyles.f16w500.copyWith(
                        color: isSelected ? AppColors.white : AppColors.grey),
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: 10,
          );
        },
        itemCount: kategories.length,
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final Function(String) onChanged;
  const _TextField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: AppColors.lightGrey,
            ),
          ),
          filled: true,
          fillColor: AppColors.lightGrey,
          hintText: 'Быстрый поиск',
          hintStyle: AppTextStyles.f16w500.copyWith(color: AppColors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.grey,
          )),
    );
  }
}
