import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class ChartData {
    var steps as Array<Number>;

    function initialize(steps as Array<Number>) {
        self.steps = steps;
    }
}

class BarChartView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var todaysActivity = ActivityMonitor.getInfo();
        var history = ActivityMonitor.getHistory();
        var dailySteps = new Array<Number>[history.size() + 1];
        dailySteps[dailySteps.size() - 1] = todaysActivity.steps;
        for (var i = 0; i < history.size(); ++i) {
            dailySteps[dailySteps.size() - i - 2] = history[i].steps;
        }
        var data = new ChartData(dailySteps);

        drawChart(dc, data);
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
    }

    function onHide() as Void {
    }

    private function drawChart(dc as Dc, data as ChartData) {
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