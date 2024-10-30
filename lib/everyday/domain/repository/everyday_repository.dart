import 'package:myapp/everyday/domain/entities/today.dart';
//

// A repository in clean architecture acts as an abstraction layer between the
// domain layer (business logic) and data sources (like APIs, databases, local
// storage). Think of it as a collection of methods that handle all data operations,
// hiding the complexity of where and how the data is actually stored or retrieved.

// I think the main point is that the repository handles all data operations

// Think of a repository like a librarian:

// You (the use case) ask for a book (data)
// The librarian (repository) knows:

// Where to look (data sources)
// How to get it (API calls, database queries)
// Where they might have a copy already (caching)
// How to handle different situations (error handling)

// You don't need to know HOW they get the book, just that they can get it for you

abstract class EverydayRepository {
  Future<Today> addToday(Today today);
  Future<List<Today>> readEveryday();
  Future<void> uploadEveryday();
  Future<void> deleteToday(String id);
}

// NB ABOUT ABSTRACT CLASSES

// When a class implements an abstract class, if that abstract class has a constructor
// the class implementing it doesn't have to call the super constructor

// if the class extends, it has to call the super constructor.

// When a class implements an abstract class, it must provide its own
// implementation for all methods - abtract and concrete, it must also provide
// its own implementation for all variables.

// When a class extends an abstract class, it must provide its own implementation
// of only the abstract methods, it inherits the concrete methods and can be accessed
// using super.method();