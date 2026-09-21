class Book {
  String title;
  String author;
  double price;
  bool isBorrowed;

  Book({
    required this.title,
    required this.author,
    required this.price,
    this.isBorrowed = false,
  });
}

class Library {
  final List<Book> _books = [];

  void addBook(Book book) {
    _books.add(book);
  }

  List<Book> getAvailableBooks() {
    return _books.where((book) => book.isBorrowed == false).toList();
  }

  double getTotalValue() {
    return _books.fold(0.0, (sum, book) => sum + book.price);
  }
}

void main() {
  final library = Library();

  library.addBook(Book(title: 'Dune', author: 'Frank Herbert', price: 5000.0));
  library.addBook(Book(title: '1984', author: 'George Orwell', price: 3000.0, isBorrowed: true));
  library.addBook(Book(title: 'Clean Code', author: 'Robert Martin', price: 7000.0));
  library.addBook(Book(title: 'Sapiens', author: 'Yuval Noah Harari', price: 4500.0));

  print('Доступные книги:');
  for (var book in library.getAvailableBooks()) {
    print('${book.title} , ${book.author}');
  }

  print('\nОбщая стоимость коллекции: ${library.getTotalValue()}');
}