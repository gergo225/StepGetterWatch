import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

enum StepPeriod {
    DAY,
    WEEK
}

class GraphData {
    var steps as Array<Number>;

    function initialize(steps as Array<Number>) {
        self.steps = steps;
    }
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

        var data = new GraphData([200, 1660, 2000, 400, 1200, 700, 300]);
        drawGraph(dc, data);


        // var midX = dc.getWidth() / 2;
        // var midY = dc.getHeight() / 2;

        // dc.drawText(
        //     midX,
        //     midY - 20,
        //     Graphics.FONT_MEDIUM,
        //     "Step count:",
        //     Graphics.TEXT_JUSTIFY_CENTER
        // );

        // var currentSteps = getStepCount();
        // dc.drawText(
        //     midX,
        //     midY + 20,
        //     Graphics.FONT_LARGE,
        //     currentSteps,
        //     Graphics.TEXT_JUSTIFY_CENTER
        // );
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

    private function drawGraph(dc as Dc, data as GraphData) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);
 
        // set max bar height (px)
        var maxBarHeightPercentage = 0.6;
        // var bottomBarMarginPercentage = 0.2;
        var maxBarHeight = (dc.getHeight() * maxBarHeightPercentage).toNumber();

        // get all steps
        // calculate max steps
        var steps = data.steps;
        var maxSteps = steps[0];
        for (var i = 0; i < steps.size(); ++i) {
            if (steps[i] > maxSteps) {
                maxSteps = steps[i];
            }
        }

        // calculate for each day what percentage it makes up compared to max
        // calculate size of bar based on percentage
        var barHeights = new Array<Number>[steps.size()];
        for (var i = 0; i < steps.size(); ++i) {
            var stepCount = steps[i];
            var percentageOfMax = stepCount.toFloat() / maxSteps.toFloat();
            barHeights[i] = (percentageOfMax * maxBarHeight.toFloat()).toNumber();
        }

        // draw bars
        var width = dc.getWidth();
        var horizontalPadding = (width * 0.1).toNumber();
        var oneBarHorizontalSpace = (width - 2 * horizontalPadding) / steps.size();
        var barWidth = 10;
        for (var i = 0; i < steps.size(); ++i) {
            var barX = i * oneBarHorizontalSpace + horizontalPadding;
            var barHeight = barHeights[i];
            var barY = maxBarHeight - barHeight;

            dc.fillRectangle(barX, barY, barWidth, barHeight);
        }
    }
}
