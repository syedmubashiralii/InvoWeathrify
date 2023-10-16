import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoweathrify/controller/weather_controller.dart';
import 'package:invoweathrify/view/core/constants.dart';
import 'package:invoweathrify/view/home/home_page.dart';
import 'package:invoweathrify/view/search/widgets/loading_widget.dart';
import 'package:invoweathrify/view/search/widgets/suggestions_widget.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final WeatherController weatherCtrl = Get.put(WeatherController());
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        title: const Text('INVOWEATHRIFY', style: whiteTxt22),
        centerTitle: true,
        backgroundColor: blackColor,
        elevation: 0,
      ),
      body: Container(
        // decoration: const BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage("assets/splash.png"), fit: BoxFit.fill)),
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: screenSize.width,
                  height: 60,
                  child: TextFormField(
                    controller: _searchCtrl,
                    onFieldSubmitted: (value) async {
                      await weatherCtrl.getWeatherData(
                          savedPlace: _searchCtrl.text.trim());
                    },
                    style: whiteTxt14,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: whiteClr24),
                      contentPadding: const EdgeInsets.only(left: 20),
                      hintText: 'Search for City',
                      hintStyle: white38Txt14,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      filled: true,
                      fillColor: whiteClr24,
                    ),
                  ),
                ),
                sbHeight30,
                GetBuilder<WeatherController>(
                    init: WeatherController(),
                    builder: (controller) {
                      if (controller.isLoading) {
                        return const SearchLoadingEffect();
                      } else if (controller.isError) {
                        return const Text('Unable to find Place.',
                            style: whiteTxt20);
                      } else if (_searchCtrl.text.isEmpty) {
                        return SearchSuggestions();
                      } else if (controller.weatherData.city != null) {
                        return InkWell(
                          // highlightColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          onTap: () async {
                            await controller.getWeatherData(
                                savedPlace: _searchCtrl.text.trim());
                            await Get.offAll(() => HomePage());
                          },
                          child: Container(
                            width: screenSize.width * 9,
                            height: 80,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: whiteClr24,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  controller.weatherData.city!.name!,
                                  style: whiteTxt22,
                                ),
                                Text(
                                  'Country : ${controller.weatherData.city!.country!}',
                                  style: white38Txt14,
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Text('');
                      }
                    }),
              ],
            ),
          )),
        ),
      ),
    );
  }
}
