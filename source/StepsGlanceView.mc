import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Time;


(:glance)
class StepsGlanceView extends WatchUi.GlanceView {
    function initialize() {
        GlanceView.initialize();
    }

    function onLayout(dc as Dc) {
    }

    function onShow() {
    }

    function onUpdate(dc as Dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

        var weekStepCount = getThisWeekStepCount();
        var weekStepText = format("This week: $1$", [weekStepCount]);
        var lastSevenDaysStepCount = getLastSevenDaysStepCount();
        var lastSevenDaysText = format("Last 7 days: $1$", [lastSevenDaysStepCount]);

        dc.drawText(0, 5, Graphics.FONT_XTINY, weekStepText, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(0, 25, Graphics.FONT_XTINY, lastSevenDaysText, Graphics.TEXT_JUSTIFY_LEFT);
    }

    private function getThisWeekStepCount() {
        var todaysInfo = ActivityMonitor.getInfo();
        var totalStepCount = todaysInfo.steps;

        var history = ActivityMonitor.getHistory();
        var daysUntilMonday = getDaysUntilMonday();

        for (var i = 0; i < history.size() && i < daysUntilMonday; ++i) {
            var dailyStepCount = history[i].steps;
            totalStepCount += dailyStepCount;
        }

        return totalStepCount;
    }

    private function getDaysUntilMonday() as Number {
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        
        if (today.day_of_week == 1) {
            return 7;
        } else {
            return today.day_of_week - 2;
        }
    }

    private function getLastSevenDaysStepCount() {
        var todaysInfo = ActivityMonitor.getInfo();
        var totalStepCount = todaysInfo.steps;

        var history = ActivityMonitor.getHistory();

        for (var i = 0; i < history.size(); ++i) {
            var dailyStepCount = history[i].steps;
            totalStepCount += dailyStepCount;
        }

        return totalStepCount;
    }
}