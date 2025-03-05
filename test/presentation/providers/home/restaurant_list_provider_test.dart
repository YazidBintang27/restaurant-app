import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/remote/service/api_service.dart';
import 'package:restaurant_app/presentation/providers/home/restaurant_list_provider.dart';
import 'package:restaurant_app/utils/app_list_result_state.dart';
import '../../../mock_restaurant_list.dart';
import 'restaurant_list_provider_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late RestaurantListProvider provider;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    provider = RestaurantListProvider(mockApiService);
  });

  tearDown(() {
    reset(mockApiService);
  });

  test("Memastikan state awal provider harus didefinisikan.", () {
    expect(provider.resultState, isA<AppListNoneState>());
  });

  test("Memastikan harus mengembalikan daftar restoran ketika pengambilan data API berhasil.", () async {
    when(mockApiService.getListRestaurant())
        .thenAnswer((_) async => MockRestaurant.sampleRestaurantList);

    await provider.getRestaurantList();

    expect(provider.resultState, isA<AppListLoadedState>());
    final state = provider.resultState as AppListLoadedState;
    expect(state.data.count, 3);
    expect(state.data.restaurants[0].name, "Warung Makan Sederhana");
    expect(state.data.restaurants[1].name, "Bakso Pak Kumis");
    expect(state.data.restaurants[2].name, "Sate Ayam Madura");
  });

  test(
      "Memastikan harus mengembalikan kesalahan ketika pengambilan data API gagal.",
      () async {
    when(mockApiService.getListRestaurant())
        .thenThrow(Exception("Gagal mengambil data restoran"));

    await provider.getRestaurantList();

    expect(provider.resultState, isA<AppListErrorState>());
    expect((provider.resultState as AppListErrorState).error,
        "Exception: Gagal mengambil data restoran");
  });
}
