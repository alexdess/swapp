import 'package:Swapp/widget/ReusableAppBar.dart';
import 'package:flutter/material.dart';

class InfosGeneral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar().setAppBar(context, "Swapp", withInfo: false),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            EntryItem(data[index]),
        itemCount: data.length,
      ),
    );
  }
}

class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

final List<Entry> data = <Entry>[
  Entry(
    'How it works ?',
    <Entry>[
      Entry(
        "Swapp is a cross-platform application that uses your computer or phone camera and connects you to other participants via video conference.\nSign up by simply adding your email address\nStart chatting with other participants: talk to someone that share a common interest, ask for recommendation (film, movie, book, …), practice a new language, show your talents or just have a drink. Possibilities are endless.\nDon’t worry, we will help you break the ice with thematic questions, and you will be able to change your correspondent at any time.\nIt's totally free, easy to use, and you will experience amazing encounters, don't hesitate any longer, go for it!",
      ),
    ],
  ),
  Entry(
    'Who are we?',
    <Entry>[
      Entry(
          " We are a team of 5 friends from the same village. Graduates and students with different backgrounds, we decided to develop a solution to create social interaction during the confinement. Our goal is to entertain people suffering from boredom and loneliness while being isolated at home."),
    ],
  ),
  Entry(
    'FAQ',
    <Entry>[
      Entry(
        'Can I choose my correspondent?',
        <Entry>[
          Entry(
              "Swapp connects you according to the criteria you selected. You can to another correspondent by clicking the switch button.")
        ],
      ),
      Entry("Is it safe for children to use?", <Entry>[
        Entry(
            "Explicit content is totally prohibited on Swapp. You can report any user that don’t follow our rules. However, the age limit of Swapp is 16 and therefore the app should not be used by children.")
      ]),
      Entry("How do I contact a Swapp representative?", <Entry>[
        Entry(
            "You can reach us by sending an email to our mail box Swapp1772@gmail.com. Every question will be answered as soon as possible.")
      ]),
    ],
  ),
];

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
