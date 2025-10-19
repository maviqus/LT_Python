import 'package:get/get.dart';
import '../../../repositories/quotes_repo.dart';
import '../../../models/quote_model.dart';

class HomeController extends GetxController {
  final Rx<Quote?> quote = Rx<Quote?>(null);
  final RxBool isLoadingQuote = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    isLoadingQuote.value = true;
    final q = await QuotesRepo.fetchQuote();
    quote.value = q;
    isLoadingQuote.value = false;
  }
}
