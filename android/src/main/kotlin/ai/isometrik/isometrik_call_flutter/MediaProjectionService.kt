package ai.isometrik.isometrik_call_flutter

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.media.projection.MediaProjection
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class MediaProjectionService : Service() {

    companion object {
        private const val NOTIFICATION_ID = 1001
        private const val CHANNEL_ID = "media_projection_channel"
        private const val CHANNEL_NAME = "Media Projection"
    }

    private var mediaProjection: MediaProjection? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        try {
            android.util.Log.d("MediaProjectionService", "Attempting to start foreground service")
            val notification = createNotification()
            startForeground(NOTIFICATION_ID, notification)
            android.util.Log.d(
                    "MediaProjectionService",
                    "✅ Successfully started foreground service"
            )
            return START_NOT_STICKY
        } catch (e: SecurityException) {
            android.util.Log.e(
                    "MediaProjectionService",
                    "SecurityException starting foreground: ${e.message}",
                    e
            )
            // We cannot fall back to regular service - MediaProjection requires foreground service
            android.util.Log.e(
                    "MediaProjectionService",
                    "Cannot start MediaProjection without foreground service"
            )
            stopSelf()
            return START_NOT_STICKY
        } catch (e: Exception) {
            android.util.Log.e(
                    "MediaProjectionService",
                    "Error starting foreground: ${e.message}",
                    e
            )
            stopSelf()
            return START_NOT_STICKY
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel =
                    NotificationChannel(
                            CHANNEL_ID,
                            CHANNEL_NAME,
                            NotificationManager.IMPORTANCE_LOW
                    )
            channel.description = "Media projection service channel"
            val notificationManager =
                    getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        android.util.Log.d("MediaProjectionService", "Creating notification with open app intent")

        // Create intent to open the app when notification is clicked
        val openAppIntent = Intent("ai.isometrik.isometrik_call_flutter.OPEN_APP")
        android.util.Log.d(
                "MediaProjectionService",
                "Created open app intent: ${openAppIntent.action}"
        )

        val openAppPendingIntent =
                PendingIntent.getBroadcast(
                        this,
                        1,
                        openAppIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
        android.util.Log.d(
                "MediaProjectionService",
                "Created pending intent for notification click"
        )

        val notification =
                NotificationCompat.Builder(this, CHANNEL_ID)
                        .setContentTitle("Screen Sharing Active")
                        .setContentText("Tap to open app")
                        .setSmallIcon(android.R.drawable.ic_dialog_info)
                        .setPriority(NotificationCompat.PRIORITY_LOW)
                        .setOngoing(true)
                        .setContentIntent(openAppPendingIntent) // Make notification clickable
                        .build()

        android.util.Log.d(
                "MediaProjectionService",
                "Notification created successfully with content intent"
        )
        return notification
    }

    override fun onDestroy() {
        super.onDestroy()
        // When service is destroyed (e.g., by system), notify Flutter
        android.util.Log.d(
                "MediaProjectionService",
                "Service being destroyed, broadcasting stop event"
        )
        val intent = Intent("ai.isometrik.isometrik_call_flutter.SCREEN_SHARING_STOPPED")
        sendBroadcast(intent)
        stopForeground(true)
    }
}
