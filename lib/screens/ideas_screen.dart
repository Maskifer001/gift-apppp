import 'package:flutter/material.dart';
import 'package:giftsbyai/constants/styles.dart';
import 'package:giftsbyai/screens/landing_screen.dart';

class IdeasScreen extends StatelessWidget {
  final String? gptReponseData;
  const IdeasScreen({Key? key, required this.gptReponseData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (gptReponseData == null) {
      // If content is null, display a placeholder or handle it according to your app's logic
      return Scaffold(
        body: Center(
          child: Text(
            "No gift ideas available.",
            style: kSubTitleText,
          ),
        ),
      );
    }

    List<String> giftIdeas = gptReponseData!.split('\n'); // Split response into individual lines

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "The AI has spoken 🥳",
              style: kTitleText,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: giftIdeas.length,
              itemBuilder: (context, index) {
                var ideaParts = giftIdeas[index].split(':'); // Split the idea into title and description
                var title = ideaParts[0].trim();
                title = title.replaceAll('*', ''); // Remove any special characters (if any)
                var description = ideaParts.length > 1 ? ideaParts[1].trim() : ''; 
                description = description.replaceAll('*', ''); // Remove any special characters (if any)
               
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (title.isNotEmpty)
                            Text(
                              title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18), // Highlighting the title
                            ),
                          const SizedBox(height: 5),
                          if (description.isNotEmpty)
                            Text(
                              description,
                              style: const TextStyle(fontSize: 16),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LandingScreen(),
              ));
            },
            child: const Text("Get more ideas"),
          ),
        ],
      ),
    );
  }
}
