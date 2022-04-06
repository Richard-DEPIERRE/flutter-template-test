import 'package:flutter_test/flutter_test.dart';
import 'package:unittest/article.dart';
import 'package:unittest/news_change_notifier.dart';
import 'package:unittest/news_service.dart';
import 'package:mocktail/mocktail.dart';

// SIMULATING WITH MOCK VARIABLES SO THAT THE TEST DEPENDS ON THE CODE AND NOT THE VARIABLES
class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  // RUNS BEFORE EVERY TEST
  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test(
    "initial values are correct",
    () {
      expect(sut.articles, []);
      expect(sut.isLoading, false);
    },
  );

  group('getArticles', () {
    final List<Article> articlesFromService = [
      Article(title: "Test1", content: "Test1 content"),
      Article(title: "Test2", content: "Test2 content"),
      Article(title: "Test3", content: "Test3 content"),
    ];
    void arrangeNewsServiceReturns3Articles() {
      when(() => mockNewsService.getArticles()).thenAnswer(
        (_) async => articlesFromService,
      );
    }

    test(
      "gets articles using NewsService",
      () async {
        arrangeNewsServiceReturns3Articles();
        await sut.getArticles();
        verify(() => mockNewsService.getArticles()).called(1);
      },
    );
    test(
      """indicates loading of data,
      sets articles to the ones from the service,
      indicates that data is not being loaded anymore""",
      () async {
        arrangeNewsServiceReturns3Articles();
        final Future<void> future = sut.getArticles();
        expect(sut.isLoading, true);
        await future;
        expect(sut.articles, articlesFromService);
        expect(sut.isLoading, false);
      },
    );
  });
}
