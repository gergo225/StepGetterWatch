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

        var data = new GraphData([1200, 1660, 2000, 400, 1200, 700, 1300]);
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
 
        var screenHeight = dc.getHeight();
        // set max bar height (px)
        var maxBarHeightPercentage = 0.5;
        // var bottomBarMarginPercentage = 0.2;
        var maxBarHeight = (screenHeight * maxBarHeightPercentage).toNumber();
        var steps = data.steps;
        var barCount = steps.size();

        // get all steps
        // calculate max steps
        var maxSteps = steps[0];
        for (var i = 0; i < barCount; ++i) {
            if (steps[i] > maxSteps) {
                maxSteps = steps[i];
            }
        }

        // calculate for each day what percentage it makes up compared to max
        // calculate size of bar based on percentage
        var barHeights = new Array<Number>[barCount];
        for (var i = 0; i < barCount; ++i) {
            var stepCount = steps[i];
            var percentageOfMax = stepCount.toFloat() / maxSteps.toFloat();
            barHeights[i] = (percentageOfMax * maxBarHeight.toFloat()).toNumber();
        }

        // draw bars
        var screenWidth = dc.getWidth();
        var horizontalPadding = (screenWidth * 0.1).toNumber();
        var oneBarHorizontalSpace = Math.round((screenWidth - 2 * horizontalPadding).toFloat() / barCount);
        var barWidth = 10;
        var bottomMargin = screenHeight * 0.2;
        for (var i = 0; i < barCount; ++i) {
            var barX = i * oneBarHorizontalSpace + horizontalPadding + Math.round(oneBarHorizontalSpace / 2.0 - barWidth / 2.0);
            var barHeight = barHeights[i];
            var barY = screenHeight - barHeight - bottomMargin;

            dc.fillRectangle(barX, barY, barWidth, barHeight);
        }
    }
}
