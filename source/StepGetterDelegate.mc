import Toybox.Lang;
import Toybox.WatchUi;

class StepGetterDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new StepGetterMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}