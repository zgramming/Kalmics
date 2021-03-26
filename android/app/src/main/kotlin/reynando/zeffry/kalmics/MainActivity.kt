package reynando.zeffry.kalmics

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL_MINIMIZE = "channel_minimize";
    private val METHOD_MINIMZE = "minimize_app";
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_MINIMIZE).setMethodCallHandler {
            call, result ->
                if(call.method == METHOD_MINIMZE ){
                    val resultMinimize = this.moveTaskToBack(true);
                    if(resultMinimize){
                        result.success(true);
                    }else{
                        result.error("CANT_MOVE_TO_RECENT","Cant move to recent apps",null);
                    }
                }else{
                    result.notImplemented();
                }
        }
    }

}
