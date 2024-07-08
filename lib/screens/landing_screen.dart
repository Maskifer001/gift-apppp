import 'package:flutter/material.dart';
import 'package:giftsbyai/constants/styles.dart';
import 'package:giftsbyai/screens/ideas_screen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const List<String> listOfRelations = <String>[
  'Friend',
  'Partner',
  'Spouse',
  'Sibling'
];
const List<String> listOfOccasions = <String>[
  "Valentine's Day",
  'Birthday',
  'Anniversary',
  'Retirement'
];

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  String gender = "prefer not to say";
  String firstDropdownValue = listOfRelations.first;
  String secondDropdownValue = listOfOccasions.first;
  bool _isLoading = false; // State variable to control the visibility of the loader

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "gifts by 🤖",
                style: kTitleText,
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "who is the gift for?",
                style: kSubTitleText,
              ),
            ),
            Center(
              child: DropdownButton<String>(
                value: firstDropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    firstDropdownValue = value!;
                  });
                },
                items: listOfRelations
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "what do they identify as?",
                style: kSubTitleText,
              ),
            ),
            RadioListTile(
              title: const Text("Male"),
              value: "male",
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text("Female"),
              value: "female",
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value.toString();
                });
              },
            ),
            RadioListTile(
              title: const Text("Prefer not to say"),
              value: "prefer not to say",
              groupValue: gender,
              onChanged: (value) {
                setState(() {
                  gender = value.toString();
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "what is the occasion?",
                style: kSubTitleText,
              ),
            ),
            Center(
              child: DropdownButton<String>(
                value: secondDropdownValue,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    secondDropdownValue = value!;
                  });
                },
                items: listOfOccasions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "tell us about their hobbies or interests",
                style: kSubTitleText,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText:
                      'Enter a hobby/interest (Example: Playing Football, Gardening, etc)',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some hobbies';
                  }
                  return null;
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: _isLoading
                    ? const CircularProgressIndicator() // Show loader when isLoading is true
                    : ElevatedButton(
                        onPressed: () async {
                          const apiKey = "AIzaSyAAxoi3l5qj7owhtmuW_YiOuD4buV6H1c8";
                         
                          setState(() {
                            _isLoading = true; // Set isLoading to true when button is pressed
                          });
                          // For text-only input, use the gemini-pro model
                          final model =
                              GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
                          final content = [
                            Content.text(
                                'Suggest gift ideas for someone who is realted to me as $firstDropdownValue of $gender gender for the occasion of $secondDropdownValue in budget less than 10,000 rupees with ${_controller.value.text} as hobbies. metion the price also.')
                          ];
                          final response = await model.generateContent(content);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => IdeasScreen(
                                    gptReponseData: response.text,
                                  )));
                          setState(() {
                            _isLoading = false; // Set isLoading to false after request is complete
                          });
                        },
                        child: const Center(child: Text("Generate Gift Ideas")),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
