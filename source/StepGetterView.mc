import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

enum StepPeriod {
    DAY,
    WEEK
}

class StepGetterView extends WatchUi.View {
    var period as StepPeriod = DAY;

    function initialize(period as StepPeriod) {
        self.period = period;
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var midX = dc.getWidth() / 2;
        var midY = dc.getHeight() / 2;

        dc.drawText(
            midX,
            midY - 20,
            Graphics.FONT_MEDIUM,
            "Step count:",
            Graphics.TEXT_JUSTIFY_CENTER
        );

        var currentSteps = getStepCount();
        dc.drawText(
            midX,
            midY + 20,
            Graphics.FONT_LARGE,
            currentSteps,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    private function getStepCount() {
        switch (self.period) {
            case DAY:
                return getTodaysStepCount();
            case WEEK:
                return getThisWeekStepCount();
        }

        return -1;
    }

    private function getTodaysStepCount() {
        var activityInfo = ActivityMonitor.getInfo();
        var currentStepCount = activityInfo.steps;
        return currentStepCount;
    }

    private function getThisWeekStepCount() {
        var history = ActivityMonitor.getHistory();
        var totalStepCount = 0;

        for (var i = 0; i < history.size(); ++i) {
            var dailyStepCount = history[i].steps;
            totalStepCount += dailyStepCount;
        }

        return totalStepCount;
    }
}
