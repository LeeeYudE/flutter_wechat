import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  static final EventBus Event_Bus = EventBus();

  static void fire<T>(T event) => Event_Bus.fire(event);
}
