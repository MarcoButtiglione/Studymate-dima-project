import 'package:flutter/material.dart';
import 'package:studymate/screens/Authenticated/profilePage/components/own_lessons_profile_page.dart';

enum ProfilePageSection { onwlesson, saved }

class BodyProfilePage extends StatefulWidget {
  @override
  State<BodyProfilePage> createState() => _BodyProfilePageState();
}

class _BodyProfilePageState extends State<BodyProfilePage> {
  ProfilePageSection selectedView = ProfilePageSection.onwlesson;

  bool isOwnLesson() {
    if (selectedView == ProfilePageSection.onwlesson) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SegmentedButton<ProfilePageSection>(
          segments: const <ButtonSegment<ProfilePageSection>>[
            ButtonSegment<ProfilePageSection>(
                value: ProfilePageSection.onwlesson,
                label: Text('Own lessons'),
                icon: Icon(Icons.calendar_view_day)),
            ButtonSegment<ProfilePageSection>(
                value: ProfilePageSection.saved,
                label: Text('Saved'),
                icon: Icon(Icons.favorite)),
          ],
          selected: <ProfilePageSection>{selectedView},
          onSelectionChanged: (Set<ProfilePageSection> newSelection) {
            setState(() {
              // By default there is only a single segment that can be
              // selected at one time, so its value is always the first
              // item in the selected set.
              selectedView = newSelection.first;
            });
          },
        ),
        const SizedBox(height: 20,),
        Container(
          child: isOwnLesson()
              ? OwnLessonsProfilePage()
              : Text('saved'),
        )
      ],
    );
  }
}
