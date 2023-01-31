import 'package:bloc/bloc.dart';
import 'package:story_way/presentation/stories/state/story_event_state.dart';

import '../../../domain/models/user_story_model.dart';

class StoryEventCubit extends Cubit<StoryEventState> {
  StoryEventCubit()
      : super(
          StoryEventState(event: StoryEvent.RESUMED),
        );

  void fire({required StoryEvent event}) {
    emit(
      state.copy(
        event: event,
      ),
    );
  }
}
