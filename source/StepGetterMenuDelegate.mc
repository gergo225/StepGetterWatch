import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class StepGetterMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :today_steps_label) {
            System.println("Daily steps");
        } else if (item == :this_week_steps) {
            System.println("Weekly steps");
        } else if (item == :this_month_steps) {
            System.println("Monthly steps");
        }
    }

}