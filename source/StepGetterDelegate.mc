import Toybox.Lang;
import Toybox.WatchUi;

class StepGetterDelegate extends WatchUi.BehaviorDelegate {
    private var view as View;

    function initialize(view as WatchUi.View) {
        BehaviorDelegate.initialize();
        self.view = view;
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new StepGetterMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onNextPage() as Boolean {
        if (view instanceof BarChartView) {
            view.moveToPreviousDay();
        }
        return true;
    }

    function onPreviousPage() as Boolean {
        if (view instanceof BarChartView) {
            view.moveToNextDay();
        }
        return true;
    }
}