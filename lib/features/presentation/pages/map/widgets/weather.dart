import 'package:flutter/material.dart';
import 'package:stravaclone/features/domain/entity/weather.dart';



class weatherAPIWidget extends StatelessWidget {
  final List<Weather> hours;
  const weatherAPIWidget({
    super.key,required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        const SliverAppBar(
          leading: Icon(Icons.today, color: Colors.deepOrange,),
          leadingWidth: 50,
          title: Text('Weather Today', style: TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 25)),
          centerTitle: true,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
        ),
        SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('${hours[index].time}',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),),
                            Row(
                              children: [
                                Image.network('${hours[index].image}'),
                                Text(
                                    '${hours[index].temp_c} C',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                const Icon(Icons.water_drop),
                                Text(
                                    '${hours[index].chance_of_rain} %',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    )),
                              ],
                            ),

                          ],
                        ),
                        const SizedBox(height: 10,),
                        Text('${hours[index].condition}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color : Colors.lightBlue
                          ),),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                RichText(
                                    text: TextSpan(
                                      text: 'Precipitation : ',
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan> [
                                        TextSpan(
                                          text : '${hours[index].precip_mm} %',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.deepOrange
                                          )
                                        )
                                      ]
                                    ),
                                ),
                                const Divider(),
                                RichText(
                                  text: TextSpan(
                                      text: 'Wind :',
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan> [
                                        TextSpan(
                                            text : '${hours[index].wind_mph} mph',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrange
                                            )
                                        )
                                      ]
                                  ),
                                ),
                                const Divider(),
                                RichText(
                                  text: TextSpan(
                                      text: 'Humidity :',
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan> [
                                        TextSpan(
                                            text : '${hours[index].humidity} %',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrange
                                            )
                                        )
                                      ]
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                      text: 'Cloud : ',
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan> [
                                        TextSpan(
                                            text : '${hours[index].cloud} %',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrange
                                            )
                                        )
                                      ]
                                  ),
                                ),
                                const Divider(),
                                RichText(
                                  text: TextSpan(
                                      text: 'UV Max : ',
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan> [
                                        TextSpan(
                                            text : '${hours[index].uv}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrange
                                            )
                                        )
                                      ]
                                  ),
                                ),
                                const Divider(),
                                RichText(
                                  text: TextSpan(
                                      text: 'Wind Degree : ',
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan> [
                                        TextSpan(
                                            text : '${hours[index].wind_degree}',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrange
                                            )
                                        )
                                      ]
                                  ),
                                ),
                                const SizedBox(height: 20,)
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
               childCount: hours.length,
            ),
        )
      ],
    );
  }
}

