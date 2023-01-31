import 'package:equatable/equatable.dart';

enum StoryEvent {
  GO_NEXT_USER,
  GO_PREVIOUS_USER,
  GO_NEXT_STORY,
  GO_PREVIOUS_STORY,
  ON_HOLD,
  RESUMED
}

class StoryEventState extends Equatable {
  final StoryEvent event;

  const StoryEventState({required this.event});

  @override
  List<Object?> get props => [event];

  StoryEventState copy({StoryEvent? event}) {
    return StoryEventState(event: event ?? this.event);
  }
}
