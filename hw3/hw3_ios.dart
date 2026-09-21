abstract class MediaItem {
  String id;
  String title;
  double price;

  MediaItem({required this.id, required this.title, required this.price});

  String getDetails();
}

mixin Downloadable {
  void download(String title) {
    print('Скачивание: $title');
  }
}

class Audiobook extends MediaItem with Downloadable {
  double durationHours;
  String narrator;

  Audiobook({
    required super.id,
    required super.title,
    required super.price,
    required this.durationHours,
    required this.narrator,
  });

  @override
  String getDetails() {
    return '$title (Аудиокнига), чтец: $narrator, длительность: $durationHours ч, цена: $price';
  }
}

class EBook extends MediaItem with Downloadable {
  double fileSizeMB;
  String author;

  EBook({
    required super.id,
    required super.title,
    required super.price,
    required this.fileSizeMB,
    required this.author,
  });

  @override
  String getDetails() {
    return '$title (Электронная книга), автор: $author, размер: $fileSizeMB МБ, цена: $price';
  }
}

class ShoppingCart {
  final List<MediaItem> _items = [];

  void addItem(MediaItem item) {
    _items.add(item);
  }

  double calculateTotalWithTax({double taxRate = 0.12}) {
    final total = _items.fold(0.0, (sum, item) => sum + item.price);
    return total + (total * taxRate);
  }

  List<MediaItem> filterByMaxPrice(double maxPrice) {
    return _items.where((item) => item.price <= maxPrice).toList();
  }

  void printReceipt() {
    print('=== Чек ===');
    for (var item in _items) {
      print(item.getDetails());
      if (item is Downloadable) {
        (item as Downloadable).download(item.title);
      }
    }
    print('Итого с налогом: ${calculateTotalWithTax()}');
  }
}

void main() {
  final cart = ShoppingCart();

  cart.addItem(Audiobook(
    id: '1',
    title: 'Atomic Habits',
    price: 6000.0,
    durationHours: 5.5,
    narrator: 'James Clear',
  ));

  cart.addItem(EBook(
    id: '2',
    title: 'The Pragmatic Programmer',
    price: 4000.0,
    fileSizeMB: 12.5,
    author: 'Andrew Hunt',
  ));

  cart.printReceipt();

  print('\nТовары до 5000:');
  for (var item in cart.filterByMaxPrice(5000.0)) {
    print(item.title);
  }
}