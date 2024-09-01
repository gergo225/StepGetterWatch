import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class StepGetterMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :today_steps) {
            System.println("Daily steps");
            openView(new StepGetterView(DAY));
        } else if (item == :this_week_steps) {
            System.println("Weekly steps");
            openView(new StepGetterView(WEEK));
        } else if (item == :seven_days_chart) {
            System.println("Last 7 days chart");
            var dummyData = new ChartData([1200, 1660, 2000, 400, 1200, 700, 1300]);
            openView(new BarChartView(dummyData));
        }
    }

    private function openView(view as WatchUi.View) {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        WatchUi.pushView(view, new StepGetterDelegate(), WatchUi.SLIDE_UP);
    }
}