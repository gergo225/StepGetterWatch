import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class StepGetterApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var view = new StepGetterView(DAY);
        return [view , new StepGetterDelegate(view)];
    }

    function getGlanceView() {
        var glanceView = new StepsGlanceView();
        return [glanceView];
    }

}

function getApp() as StepGetterApp {
    return Application.getApp() as StepGetterApp;
}