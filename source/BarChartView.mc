import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Time;

class ChartData {
    var dayOfWeekInitials as Array<String>;
    var steps as Array<Number>;

    function initialize(steps as Array<Number>, dayOfWeekInitials as Array<String>) {
        self.steps = steps;
        self.dayOfWeekInitials = dayOfWeekInitials;
    }
}

class BarChartView extends WatchUi.View {
    private const DAYS_OF_WEEK = ["M", "T", "W", "T", "F", "S", "S"];

    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var todaysActivity = ActivityMonitor.getInfo();
        var history = ActivityMonitor.getHistory();
        var dailySteps = new Array<Number>[history.size() + 1];
        dailySteps[0] = todaysActivity.steps;
        for (var i = 0; i < history.size(); ++i) {
            dailySteps[i + 1] = history[i].steps;
        }

        var dayOfWeekIndex = getTodaysDayOfWeekIndex();
        var daysOfWeekInitials = getDaysOfWeekInitials((dayOfWeekIndex - dailySteps.size()) % DAYS_OF_WEEK.size(), dailySteps.size());

        var data = new ChartData(dailySteps.reverse(), daysOfWeekInitials);

        drawChart(dc, data);
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
    }

    function onHide() as Void {
    }

    private function getTodaysDayOfWeekIndex() as Number {
        var today = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dayOfWeekIndex = today.day_of_week == 1 ? 6 : today.day_of_week - 1;
        return dayOfWeekIndex;
    }

    private function getDaysOfWeekInitials(startingDayIndex as Number, totalDays as Number) as Array<String> {
        if (startingDayIndex < 0) {
            startingDayIndex = DAYS_OF_WEEK.size() - (-startingDayIndex % DAYS_OF_WEEK.size());
        }
        var initials = new Array<String>[totalDays];
        for (var i = 0; i < initials.size(); ++i) {
            var dayIndex = (startingDayIndex + i) % DAYS_OF_WEEK.size();
            initials[i] = DAYS_OF_WEEK[dayIndex];
        }

        return initials;
    }

    private function drawChart(dc as Dc, data as ChartData) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
 
        var screenHeight = dc.getHeight();
        // set max bar height (px)
        var maxBarHeightPercentage = 0.5;
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
            var percentageOfMax = maxSteps != 0 ? stepCount.toFloat() / maxSteps.toFloat() : 0;
            barHeights[i] = (percentageOfMax * maxBarHeight.toFloat()).toNumber();
        }

        // draw bars and day initials (labels below bars)
        var screenWidth = dc.getWidth();
        var horizontalPadding = (screenWidth * 0.1).toNumber();
        var oneBarHorizontalSpace = Math.round((screenWidth - 2 * horizontalPadding).toFloat() / barCount);
        var barWidth = 10;
        var bottomMargin = screenHeight * 0.3;
        for (var i = 0; i < barCount; ++i) {
            var barX = i * oneBarHorizontalSpace + horizontalPadding + Math.round(oneBarHorizontalSpace / 2.0 - barWidth / 2.0);
            var barHeight = barHeights[i];
            var barY = screenHeight - barHeight - bottomMargin;

            dc.fillRectangle(barX, barY, barWidth, barHeight);

            var textX = barX + barWidth / 2;
            var textY = screenHeight - bottomMargin;
            var text = data.dayOfWeekInitials[i];
            dc.drawText(textX, textY, Graphics.FONT_SMALL, text, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}