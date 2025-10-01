package ai.isometrik.isometrik_call_flutter

import android.app.ActivityManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.projection.MediaProjectionManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** IsometrikCallFlutterPlugin */
class IsometrikCallFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private var activityBinding: ActivityPluginBinding? = null

  private var receiverRegistered = false

  private val notificationClickReceiver =
          object : BroadcastReceiver() {
            override fun onReceive(ctx: Context?, intent: Intent?) {
              android.util.Log.d(
                      "IsometrikCallFlutter",
                      "=== NOTIFICATION CLICK RECEIVER TRIGGERED ==="
              )
              android.util.Log.d("IsometrikCallFlutter", "Received broadcast: ${intent?.action}")
              android.util.Log.d("IsometrikCallFlutter", "Intent extras: ${intent?.extras}")
              android.util.Log.d("IsometrikCallFlutter", "Context: $ctx")

              if (intent?.action == "ai.isometrik.isometrik_call_flutter.OPEN_APP") {
                android.util.Log.d(
                        "IsometrikCallFlutter",
                        "✅ Action matches! User clicked notification to open app"
                )
                android.util.Log.d(
                        "IsometrikCallFlutter",
                        "Invoking Flutter method: onOpenAppFromNotification"
                )

                try {
                  // Invoke Flutter method on main thread
                  if (activityBinding?.activity != null) {
                    activityBinding?.activity?.runOnUiThread {
                      try {
                        channel.invokeMethod("onOpenAppFromNotification", null)
                        android.util.Log.d(
                                "IsometrikCallFlutter",
                                "✅ Successfully invoked Flutter method on main thread"
                        )
                      } catch (e: Exception) {
                        android.util.Log.e(
                                "IsometrikCallFlutter",
                                "❌ Error invoking Flutter method on main thread: ${e.message}",
                                e
                        )
                      }
                    }
                  } else {
                    // Fallback: use Handler to post to main thread
                    android.os.Handler(android.os.Looper.getMainLooper()).post {
                      try {
                        channel.invokeMethod("onOpenAppFromNotification", null)
                        android.util.Log.d(
                                "IsometrikCallFlutter",
                                "✅ Successfully invoked Flutter method via Handler"
                        )
                      } catch (e: Exception) {
                        android.util.Log.e(
                                "IsometrikCallFlutter",
                                "❌ Error invoking Flutter method via Handler: ${e.message}",
                                e
                        )
                      }
                    }
                  }
                } catch (e: Exception) {
                  android.util.Log.e(
                          "IsometrikCallFlutter",
                          "❌ Error setting up main thread invocation: ${e.message}",
                          e
                  )
                }
              } else {
                android.util.Log.w(
                        "IsometrikCallFlutter",
                        "⚠️ Action mismatch. Expected: ai.isometrik.isometrik_call_flutter.OPEN_APP, Got: ${intent?.action}"
                )
              }
            }
          }

  // Add system notification listener
  private val systemNotificationReceiver =
          object : BroadcastReceiver() {
            override fun onReceive(ctx: Context?, intent: Intent?) {
              android.util.Log.d(
                      "IsometrikCallFlutter",
                      "System notification action: ${intent?.action}"
              )

              // Check if this is a system screen sharing stop
              when (intent?.action) {
                Intent.ACTION_CLOSE_SYSTEM_DIALOGS -> {
                  // System dialog closed - might be screen sharing stopped
                  android.util.Log.d(
                          "IsometrikCallFlutter",
                          "System dialog closed, checking screen sharing status"
                  )
                  // Add a delay to let the system process the stop
                  Thread {
                            Thread.sleep(500) // Wait 500ms
                            checkAndStopScreenSharingIfNeeded()
                          }
                          .start()
                }
                Intent.ACTION_PACKAGE_RESTARTED -> {
                  // App restarted - check screen sharing status
                  android.util.Log.d(
                          "IsometrikCallFlutter",
                          "App restarted, checking screen sharing status"
                  )
                  Thread {
                            Thread.sleep(1000) // Wait 1 second
                            checkAndStopScreenSharingIfNeeded()
                          }
                          .start()
                }
                "android.intent.action.MEDIA_PROJECTION_STOPPED" -> {
                  // Direct MediaProjection stop event
                  android.util.Log.d("IsometrikCallFlutter", "MediaProjection stopped by system")
                  forceStopScreenSharingFromSystem()
                }
                Intent.ACTION_MEDIA_BUTTON -> {
                  // Media button pressed - might be stop screen sharing
                  android.util.Log.d(
                          "IsometrikCallFlutter",
                          "Media button pressed, checking status"
                  )
                  checkAndStopScreenSharingIfNeeded()
                }
                Intent.ACTION_SCREEN_OFF -> {
                  // Screen turned off - screen sharing should stop
                  android.util.Log.d(
                          "IsometrikCallFlutter",
                          "Screen turned off, stopping screen sharing"
                  )
                  forceStopScreenSharingFromSystem()
                }
                Intent.ACTION_USER_PRESENT -> {
                  // User returned to device - check if screen sharing was stopped
                  android.util.Log.d(
                          "IsometrikCallFlutter",
                          "User present, checking screen sharing status"
                  )
                  Thread {
                            Thread.sleep(1000) // Wait 1 second
                            checkAndStopScreenSharingIfNeeded()
                          }
                          .start()
                }
              }
            }
          }

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "isometrik_call_flutter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    registerReceiver()
  }

  private fun registerReceiver() {
    if (!receiverRegistered) {
      android.util.Log.d("IsometrikCallFlutter", "Registering notification click receiver")
      val filter = IntentFilter("ai.isometrik.isometrik_call_flutter.OPEN_APP")
      android.util.Log.d(
              "IsometrikCallFlutter",
              "Created intent filter for: ${filter.actionsIterator().next()}"
      )

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        context.registerReceiver(notificationClickReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        android.util.Log.d(
                "IsometrikCallFlutter",
                "Registered notification click receiver with RECEIVER_NOT_EXPORTED flag"
        )
      } else {
        context.registerReceiver(notificationClickReceiver, filter)
        android.util.Log.d(
                "IsometrikCallFlutter",
                "Registered notification click receiver without export flag"
        )
      }

      // Register system notification receiver with more actions
      android.util.Log.d("IsometrikCallFlutter", "Registering system notification receiver")
      val systemFilter =
              IntentFilter().apply {
                addAction(Intent.ACTION_CLOSE_SYSTEM_DIALOGS)
                addAction("android.intent.action.MEDIA_PROJECTION_STOPPED")
                addAction(Intent.ACTION_MEDIA_BUTTON)
                addAction(Intent.ACTION_SCREEN_OFF)
                addAction(Intent.ACTION_USER_PRESENT)
                addAction(Intent.ACTION_CONFIGURATION_CHANGED)
                addAction(Intent.ACTION_PACKAGE_RESTARTED)
              }
      android.util.Log.d(
              "IsometrikCallFlutter",
              "System filter actions: ${systemFilter.actionsIterator().asSequence().toList()}"
      )

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
        context.registerReceiver(
                systemNotificationReceiver,
                systemFilter,
                Context.RECEIVER_NOT_EXPORTED
        )
        android.util.Log.d(
                "IsometrikCallFlutter",
                "Registered system notification receiver with RECEIVER_NOT_EXPORTED flag"
        )
      } else {
        context.registerReceiver(systemNotificationReceiver, systemFilter)
        android.util.Log.d(
                "IsometrikCallFlutter",
                "Registered system notification receiver without export flag"
        )
      }

      receiverRegistered = true
      android.util.Log.d("IsometrikCallFlutter", "All receivers registered successfully")
    } else {
      android.util.Log.d("IsometrikCallFlutter", "Receivers already registered, skipping")
    }
  }

  private fun unregisterReceiver() {
    if (receiverRegistered) {
      try {
        context.unregisterReceiver(notificationClickReceiver)
        context.unregisterReceiver(systemNotificationReceiver)
      } catch (_: Exception) {}
      receiverRegistered = false
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "startMediaProjectionService" -> startMediaProjectionService(result)
      "stopMediaProjectionService" -> stopMediaProjectionService(result)
      "isMediaProjectionServiceRunning" -> isMediaProjectionServiceRunning(result)
      "isScreenSharingActive" -> isScreenSharingActive(result)
      "startMediaProjectionMonitoring" -> startMediaProjectionMonitoring(result)
      "forceStopScreenSharing" -> forceStopScreenSharing(result)
      "ensureForegroundService" -> ensureForegroundService(result)
      "requestMediaProjectionPermission" -> requestMediaProjectionPermission(result)
      "checkMediaProjectionPermission" -> checkMediaProjectionPermission(result)
      "showPermissionDialog" -> showPermissionDialog(result)
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun startMediaProjectionService(result: Result) {
    android.util.Log.d("IsometrikCallFlutter", "=== STARTING MEDIA PROJECTION SERVICE ===")

    // For Android 14+, we need to ensure the FOREGROUND_SERVICE_MEDIA_PROJECTION permission is
    // granted
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
      val hasPermission =
              context.checkSelfPermission(
                      android.Manifest.permission.FOREGROUND_SERVICE_MEDIA_PROJECTION
              ) == android.content.pm.PackageManager.PERMISSION_GRANTED

      android.util.Log.d("IsometrikCallFlutter", "Android 14+ detected, permission: $hasPermission")

      if (!hasPermission) {
        android.util.Log.e(
                "IsometrikCallFlutter",
                "Missing FOREGROUND_SERVICE_MEDIA_PROJECTION permission on Android 14+"
        )

        // Show permission dialog instead of just returning error
        android.util.Log.d(
                "IsometrikCallFlutter",
                "Showing permission dialog for missing permission"
        )
        showPermissionDialog(result)
        return
      }
    }

    try {
      android.util.Log.d("IsometrikCallFlutter", "Creating intent for MediaProjectionService")
      val intent = Intent(context, MediaProjectionService::class.java)

      try {
        android.util.Log.d("IsometrikCallFlutter", "Attempting to start foreground service")
        context.startForegroundService(intent)
        android.util.Log.d("IsometrikCallFlutter", "✅ Successfully started MediaProjectionService")
        result.success(true)
      } catch (e: SecurityException) {
        android.util.Log.e(
                "IsometrikCallFlutter",
                "SecurityException starting service: ${e.message}",
                e
        )

        // Cannot fall back to regular service - MediaProjection requires foreground service
        android.util.Log.e(
                "IsometrikCallFlutter",
                "Cannot start MediaProjectionService without foreground service"
        )
        result.error(
                "PERMISSION_ERROR",
                "Cannot start MediaProjectionService: Media projection requires a foreground service. Please ensure the FOREGROUND_SERVICE_MEDIA_PROJECTION permission is granted in system settings.",
                null
        )
      }
    } catch (e: Exception) {
      android.util.Log.e(
              "IsometrikCallFlutter",
              "❌ Error starting MediaProjectionService: ${e.message}",
              e
      )
      result.error("SERVICE_ERROR", "Failed to start media projection service: ${e.message}", null)
    }
  }

  private fun checkMediaProjectionPermission(result: Result) {
    try {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val hasPermission =
                context.checkSelfPermission(
                        android.Manifest.permission.FOREGROUND_SERVICE_MEDIA_PROJECTION
                ) == android.content.pm.PackageManager.PERMISSION_GRANTED

        android.util.Log.d(
                "IsometrikCallFlutter",
                "FOREGROUND_SERVICE_MEDIA_PROJECTION permission: $hasPermission"
        )

        if (hasPermission) {
          result.success(true)
        } else {
          // Try to request the permission
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            // For Android 14+, this permission might need to be granted through system settings
            android.util.Log.d(
                    "IsometrikCallFlutter",
                    "Permission not granted, may need system settings"
            )
            result.success(false)
          } else {
            result.success(false)
          }
        }
      } else {
        result.success(true)
      }
    } catch (e: Exception) {
      android.util.Log.e("IsometrikCallFlutter", "Error checking permission: ${e.message}", e)
      result.success(false)
    }
  }

  private fun stopMediaProjectionService(result: Result) {
    try {
      val intent = Intent(context, MediaProjectionService::class.java)
      context.stopService(intent)
      result.success(true)
    } catch (e: Exception) {
      result.error("SERVICE_ERROR", "Failed to stop media projection service: ${e.message}", null)
    }
  }

  private fun isMediaProjectionServiceRunning(result: Result) {
    try {
      val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
      val runningServices = manager.getRunningServices(Integer.MAX_VALUE)
      val serviceInfo =
              runningServices.find {
                it.service.className == "ai.isometrik.isometrik_call_flutter.MediaProjectionService"
              }

      if (serviceInfo != null) {
        val isRunning =
                serviceInfo.foreground // Check if it's actually running as foreground service
        android.util.Log.d(
                "IsometrikCallFlutter",
                "MediaProjectionService running as foreground: $isRunning"
        )
        result.success(isRunning)
      } else {
        android.util.Log.d("IsometrikCallFlutter", "MediaProjectionService not running")
        result.success(false)
      }
    } catch (e: Exception) {
      android.util.Log.e("IsometrikCallFlutter", "Error checking service status: ${e.message}", e)
      result.error(
              "SERVICE_ERROR",
              "Failed to check media projection service status: ${e.message}",
              null
      )
    }
  }

  private fun isScreenSharingActive(result: Result) {
    try {
      // Check if the service is running
      val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
      val runningServices = manager.getRunningServices(Integer.MAX_VALUE)
      val isRunning =
              runningServices.any {
                it.service.className == "ai.isometrik.isometrik_call_flutter.MediaProjectionService"
              }

      // Log the result for debugging
      android.util.Log.d("IsometrikCallFlutter", "isScreenSharingActive: serviceRunning=$isRunning")

      // Also check if there are any active MediaProjection services in the system
      val mediaProjectionManager =
              context.getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
      val hasActiveProjection =
              try {
                // This is a more direct way to check if MediaProjection is active
                val activeServices = manager.getRunningServices(Integer.MAX_VALUE)
                activeServices.any {
                  it.service.className.contains("MediaProjection") ||
                          it.service.className.contains("ScreenCapture")
                }
              } catch (e: Exception) {
                false
              }

      android.util.Log.d(
              "IsometrikCallFlutter",
              "isScreenSharingActive: hasActiveProjection=$hasActiveProjection"
      )

      result.success(isRunning && hasActiveProjection)
    } catch (e: Exception) {
      android.util.Log.e(
              "IsometrikCallFlutter",
              "Error checking screen sharing status: ${e.message}",
              e
      )
      result.error(
              "SCREEN_SHARE_ERROR",
              "Failed to check screen sharing status: ${e.message}",
              null
      )
    }
  }

  private fun startMediaProjectionMonitoring(result: Result) {
    try {
      // Start a background thread to monitor MediaProjection state directly
      Thread {
                var wasActive = false
                var consecutiveChecks = 0
                val maxConsecutiveChecks = 100 // 5 seconds at 50ms intervals

                // Wait a bit for the service to start
                Thread.sleep(1000)

                while (true) {
                  try {
                    Thread.sleep(50) // Check every 50ms for faster response

                    // Check if our service is running
                    val manager =
                            context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                    val runningServices = manager.getRunningServices(Integer.MAX_VALUE)
                    val serviceRunning =
                            runningServices.any {
                              it.service.className ==
                                      "ai.isometrik.isometrik_call_flutter.MediaProjectionService"
                            }

                    // Check for MediaProjection services more aggressively
                    val hasActiveProjection =
                            try {
                              val activeServices = manager.getRunningServices(Integer.MAX_VALUE)
                              activeServices.any {
                                it.service.className.contains("MediaProjection") ||
                                        it.service.className.contains("ScreenCapture") ||
                                        it.service.className.contains("flutter_webrtc") ||
                                        it.service.className.contains("WebRTC")
                              }
                            } catch (e: Exception) {
                              false
                            }

                    // Check if MediaProjectionManager shows no active projection
                    val hasSystemProjection =
                            try {
                              // Try to detect if system MediaProjection is actually active
                              val activeServices = manager.getRunningServices(Integer.MAX_VALUE)
                              activeServices.any {
                                it.service.className.contains("MediaProjection") ||
                                        it.service.className.contains("ScreenCapture")
                              }
                            } catch (e: Exception) {
                              false
                            }

                    android.util.Log.d(
                            "IsometrikCallFlutter",
                            "Monitoring: serviceRunning=$serviceRunning, hasActiveProjection=$hasActiveProjection, hasSystemProjection=$hasSystemProjection, consecutiveChecks=$consecutiveChecks"
                    )

                    // If service was running but now stopped, or MediaProjection stopped, broadcast
                    // stop event
                    if (wasActive &&
                                    (!serviceRunning ||
                                            !hasActiveProjection ||
                                            !hasSystemProjection)
                    ) {
                      android.util.Log.d(
                              "IsometrikCallFlutter",
                              "Screen sharing stopped, broadcasting stop event"
                      )
                      val intent =
                              Intent("ai.isometrik.isometrik_call_flutter.SCREEN_SHARING_STOPPED")
                      context.sendBroadcast(intent)

                      // Force stop our service as well
                      try {
                        val stopIntent = Intent(context, MediaProjectionService::class.java)
                        context.stopService(stopIntent)
                      } catch (e: Exception) {
                        android.util.Log.e(
                                "IsometrikCallFlutter",
                                "Error stopping service: ${e.message}",
                                e
                        )
                      }

                      break
                    }

                    // If our service is running but system projection is not, force stop
                    if (serviceRunning && !hasSystemProjection) {
                      consecutiveChecks++
                      if (consecutiveChecks >= maxConsecutiveChecks) {
                        android.util.Log.d(
                                "IsometrikCallFlutter",
                                "System projection stopped, forcing stop after $consecutiveChecks checks"
                        )
                        val intent =
                                Intent("ai.isometrik.isometrik_call_flutter.SCREEN_SHARING_STOPPED")
                        context.sendBroadcast(intent)

                        try {
                          val stopIntent = Intent(context, MediaProjectionService::class.java)
                          context.stopService(stopIntent)
                        } catch (e: Exception) {
                          android.util.Log.e(
                                  "IsometrikCallFlutter",
                                  "Error stopping service: ${e.message}",
                                  e
                          )
                        }
                        break
                      }
                    } else {
                      consecutiveChecks = 0
                    }

                    wasActive = serviceRunning && hasActiveProjection

                    // If service is not running, stop monitoring
                    if (!serviceRunning) {
                      break
                    }
                  } catch (e: Exception) {
                    android.util.Log.e(
                            "IsometrikCallFlutter",
                            "Error in monitoring thread: ${e.message}",
                            e
                    )
                    break
                  }
                }
              }
              .start()

      // Also start a more aggressive MediaProjection state checker
      Thread {
                Thread.sleep(2000) // Wait for screen sharing to start

                while (true) {
                  try {
                    Thread.sleep(100) // Check every 100ms

                    // Try to detect if MediaProjection was stopped by system
                    val manager =
                            context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                    val runningServices = manager.getRunningServices(Integer.MAX_VALUE)

                    // Look for any MediaProjection related services
                    val hasMediaProjection =
                            runningServices.any {
                              it.service.className.contains("MediaProjection") ||
                                      it.service.className.contains("ScreenCapture")
                            }

                    // If no MediaProjection services found but our service is running, force stop
                    if (!hasMediaProjection) {
                      val ourServiceRunning =
                              runningServices.any {
                                it.service.className ==
                                        "ai.isometrik.isometrik_call_flutter.MediaProjectionService"
                              }

                      if (ourServiceRunning) {
                        android.util.Log.d(
                                "IsometrikCallFlutter",
                                "MediaProjection stopped by system, forcing stop"
                        )
                        val intent =
                                Intent("ai.isometrik.isometrik_call_flutter.SCREEN_SHARING_STOPPED")
                        context.sendBroadcast(intent)

                        // Force stop our service
                        try {
                          val stopIntent = Intent(context, MediaProjectionService::class.java)
                          context.stopService(stopIntent)
                        } catch (e: Exception) {
                          android.util.Log.e(
                                  "IsometrikCallFlutter",
                                  "Error stopping service: ${e.message}",
                                  e
                          )
                        }

                        break
                      }
                    }

                    // If our service is not running, stop monitoring
                    val ourServiceRunning =
                            runningServices.any {
                              it.service.className ==
                                      "ai.isometrik.isometrik_call_flutter.MediaProjectionService"
                            }

                    if (!ourServiceRunning) {
                      break
                    }
                  } catch (e: Exception) {
                    android.util.Log.e(
                            "IsometrikCallFlutter",
                            "Error in MediaProjection checker: ${e.message}",
                            e
                    )
                    break
                  }
                }
              }
              .start()

      result.success(true)
    } catch (e: Exception) {
      android.util.Log.e("IsometrikCallFlutter", "Failed to start monitoring: ${e.message}", e)
      result.error(
              "MONITORING_ERROR",
              "Failed to start media projection monitoring: ${e.message}",
              null
      )
    }
  }

  private fun forceStopScreenSharing(result: Result) {
    try {
      // Force stop the media projection service
      val intent = Intent(context, MediaProjectionService::class.java)
      context.stopService(intent)

      // Broadcast the stop event
      val stopIntent = Intent("ai.isometrik.isometrik_call_flutter.SCREEN_SHARING_STOPPED")
      context.sendBroadcast(stopIntent)

      result.success(true)
    } catch (e: Exception) {
      android.util.Log.e(
              "IsometrikCallFlutter",
              "Failed to force stop screen sharing: ${e.message}",
              e
      )
      result.error("FORCE_STOP_ERROR", "Failed to force stop screen sharing: ${e.message}", null)
    }
  }

  private fun ensureForegroundService(result: Result) {
    try {
      android.util.Log.d(
              "IsometrikCallFlutter",
              "Ensuring MediaProjectionService is running as foreground"
      )

      // Check if service is running as foreground
      val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
      val runningServices = manager.getRunningServices(Integer.MAX_VALUE)
      val serviceInfo =
              runningServices.find {
                it.service.className == "ai.isometrik.isometrik_call_flutter.MediaProjectionService"
              }

      if (serviceInfo != null && serviceInfo.foreground) {
        android.util.Log.d("IsometrikCallFlutter", "Service is already running as foreground")
        result.success(true)
        return
      }

      // If service is not running as foreground, stop it and restart
      if (serviceInfo != null) {
        android.util.Log.d(
                "IsometrikCallFlutter",
                "Service is running but not as foreground, stopping it"
        )
        val intent = Intent(context, MediaProjectionService::class.java)
        context.stopService(intent)
        Thread.sleep(500) // Wait a bit for service to stop
      }

      // Try to start the service again
      val intent = Intent(context, MediaProjectionService::class.java)
      try {
        context.startForegroundService(intent)
        android.util.Log.d(
                "IsometrikCallFlutter",
                "✅ Successfully restarted MediaProjectionService as foreground"
        )
        result.success(true)
      } catch (e: SecurityException) {
        android.util.Log.e(
                "IsometrikCallFlutter",
                "SecurityException restarting service: ${e.message}",
                e
        )
        result.error(
                "PERMISSION_ERROR",
                "Cannot restart MediaProjectionService: Media projection requires a foreground service. Please ensure the FOREGROUND_SERVICE_MEDIA_PROJECTION permission is granted in system settings.",
                null
        )
      }
    } catch (e: Exception) {
      android.util.Log.e(
              "IsometrikCallFlutter",
              "Error ensuring foreground service: ${e.message}",
              e
      )
      result.error("SERVICE_ERROR", "Failed to ensure foreground service: ${e.message}", null)
    }
  }

  private fun checkAndStopScreenSharingIfNeeded() {
    try {
      // Check if screen sharing is still active
      val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
      val runningServices = manager.getRunningServices(Integer.MAX_VALUE)
      val serviceRunning =
              runningServices.any {
                it.service.className == "ai.isometrik.isometrik_call_flutter.MediaProjectionService"
              }

      // Also check if system MediaProjection is still active
      val hasSystemProjection =
              try {
                runningServices.any {
                  it.service.className.contains("MediaProjection") ||
                          it.service.className.contains("ScreenCapture")
                }
              } catch (e: Exception) {
                false
              }

      android.util.Log.d(
              "IsometrikCallFlutter",
              "checkAndStopScreenSharingIfNeeded: serviceRunning=$serviceRunning, hasSystemProjection=$hasSystemProjection"
      )

      if (serviceRunning) {
        android.util.Log.d(
                "IsometrikCallFlutter",
                "Service still running, checking MediaProjection status"
        )

        // If our service is running but system projection is not, force stop immediately
        if (!hasSystemProjection) {
          android.util.Log.d(
                  "IsometrikCallFlutter",
                  "System projection stopped but our service still running, forcing stop"
          )
          forceStopScreenSharingFromSystem()
        } else {
          // Force check and stop if needed
          forceStopScreenSharingFromSystem()
        }
      }
    } catch (e: Exception) {
      android.util.Log.e(
              "IsometrikCallFlutter",
              "Error checking screen sharing status: ${e.message}",
              e
      )
    }
  }

  private fun forceStopScreenSharingFromSystem() {
    try {
      android.util.Log.d("IsometrikCallFlutter", "Force stopping screen sharing from system")

      // Stop our service
      val intent = Intent(context, MediaProjectionService::class.java)
      context.stopService(intent)

      // Broadcast stop event to Flutter
      val stopIntent = Intent("ai.isometrik.isometrik_call_flutter.SCREEN_SHARING_STOPPED")
      context.sendBroadcast(stopIntent)

      // Also invoke Flutter method directly on main thread
      if (activityBinding?.activity != null) {
        activityBinding?.activity?.runOnUiThread {
          try {
            channel.invokeMethod("onStopScreenSharing", null)
          } catch (e: Exception) {
            android.util.Log.e(
                    "IsometrikCallFlutter",
                    "Error invoking Flutter method: ${e.message}",
                    e
            )
          }
        }
      } else {
        // Fallback: use Handler to post to main thread
        try {
          android.os.Handler(android.os.Looper.getMainLooper()).post {
            try {
              channel.invokeMethod("onStopScreenSharing", null)
            } catch (e: Exception) {
              android.util.Log.e(
                      "IsometrikCallFlutter",
                      "Error invoking Flutter method via Handler: ${e.message}",
                      e
              )
            }
          }
        } catch (e: Exception) {
          android.util.Log.e(
                  "IsometrikCallFlutter",
                  "Error posting to main thread: ${e.message}",
                  e
          )
        }
      }

      // Force stop any remaining MediaProjection services
      try {
        val manager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val runningServices = manager.getRunningServices(Integer.MAX_VALUE)

        // Look for any remaining MediaProjection services and try to stop them
        runningServices.forEach { service ->
          if (service.service.className.contains("MediaProjection") ||
                          service.service.className.contains("ScreenCapture")
          ) {
            android.util.Log.d(
                    "IsometrikCallFlutter",
                    "Found remaining MediaProjection service: ${service.service.className}"
            )
          }
        }
      } catch (e: Exception) {
        android.util.Log.e(
                "IsometrikCallFlutter",
                "Error checking remaining services: ${e.message}",
                e
        )
      }
    } catch (e: Exception) {
      android.util.Log.e(
              "IsometrikCallFlutter",
              "Error force stopping from system: ${e.message}",
              e
      )
    }
  }

  private fun requestMediaProjectionPermission(result: Result) {
    try {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        // Check if we already have the permission
        val hasPermission =
                context.checkSelfPermission(
                        android.Manifest.permission.FOREGROUND_SERVICE_MEDIA_PROJECTION
                ) == android.content.pm.PackageManager.PERMISSION_GRANTED

        android.util.Log.d(
                "IsometrikCallFlutter",
                "Current FOREGROUND_SERVICE_MEDIA_PROJECTION permission: $hasPermission"
        )

        if (hasPermission) {
          android.util.Log.d("IsometrikCallFlutter", "Permission already granted")
          result.success(true)
          return
        }

        // For Android 14+, we need to request this permission
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
          android.util.Log.d(
                  "IsometrikCallFlutter",
                  "Android 14+ detected - FOREGROUND_SERVICE_MEDIA_PROJECTION permission required"
          )

          // For Android 14+, this permission must be granted through system settings
          // We can't request it programmatically like normal permissions
          result.error(
                  "PERMISSION_REQUIRED",
                  "FOREGROUND_SERVICE_MEDIA_PROJECTION permission required on Android 14+. Please grant this permission in system settings.",
                  null
          )
        } else {
          result.success(true)
        }
      } else {
        result.success(true)
      }
    } catch (e: Exception) {
      android.util.Log.e("IsometrikCallFlutter", "Error requesting permission: ${e.message}", e)
      result.error("PERMISSION_ERROR", "Failed to request permission: ${e.message}", null)
    }
  }

  private fun showPermissionDialog(result: Result) {
    try {
      android.util.Log.d("IsometrikCallFlutter", "Showing permission dialog")

      // Ensure method call happens on main thread
      if (activityBinding?.activity != null) {
        activityBinding?.activity?.runOnUiThread {
          try {
            // Notify Flutter to show a permission dialog
            channel.invokeMethod(
                    "showPermissionDialog",
                    mapOf(
                            "title" to "Permission Required",
                            "message" to
                                    "Screen sharing requires the 'Media Projection' permission. Please grant this permission in your device settings.",
                            "settingsButton" to "Open Settings",
                            "cancelButton" to "Cancel"
                    )
            )
            android.util.Log.d("IsometrikCallFlutter", "✅ Successfully invoked showPermissionDialog on main thread")
            result.success(true)
          } catch (e: Exception) {
            android.util.Log.e("IsometrikCallFlutter", "❌ Error invoking showPermissionDialog on main thread: ${e.message}", e)
            result.error("DIALOG_ERROR", "Failed to show permission dialog: ${e.message}", null)
          }
        }
      } else {
        // Fallback: use Handler to post to main thread
        android.os.Handler(android.os.Looper.getMainLooper()).post {
          try {
            channel.invokeMethod(
                    "showPermissionDialog",
                    mapOf(
                            "title" to "Permission Required",
                            "message" to
                                    "Screen sharing requires the 'Media Projection' permission. Please grant this permission in your device settings.",
                            "settingsButton" to "Open Settings",
                            "cancelButton" to "Cancel"
                    )
            )
            android.util.Log.d("IsometrikCallFlutter", "✅ Successfully invoked showPermissionDialog via Handler")
            result.success(true)
          } catch (e: Exception) {
            android.util.Log.e("IsometrikCallFlutter", "❌ Error invoking showPermissionDialog via Handler: ${e.message}", e)
            result.error("DIALOG_ERROR", "Failed to show permission dialog: ${e.message}", null)
          }
        }
      }
    } catch (e: Exception) {
      android.util.Log.e("IsometrikCallFlutter", "❌ Error setting up main thread invocation for dialog: ${e.message}", e)
      result.error("DIALOG_ERROR", "Failed to show permission dialog: ${e.message}", null)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    unregisterReceiver()
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activityBinding = binding
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activityBinding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activityBinding = binding
  }

  override fun onDetachedFromActivity() {
    activityBinding = null
  }
}
