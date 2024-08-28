import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class StepGetterMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        var selectedPeriod = DAY;
        if (item == :today_steps_label) {
            System.println("Daily steps");
            selectedPeriod = DAY;
        } else if (item == :this_week_steps) {
            System.println("Weekly steps");
            selectedPeriod = WEEK;
        }

        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.pushView(new StepGetterView(selectedPeriod), new StepGetterDelegate(), WatchUi.SLIDE_UP);
    }
}