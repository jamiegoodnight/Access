/*
 * Copyright 2021 Onymos Inc
 *
 */

package com.onymos.components.initialize;

import org.json.JSONArray;
import org.json.JSONException;

import android.content.pm.PackageInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;

import android.util.Log;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;

import android.content.Context;
import android.content.ClipboardManager;
import android.content.ClipData;
import android.content.ClipDescription;

public class OnymosInitializeManager extends CordovaPlugin {

	public final String ACTION_GET_APPNAME = "getApplicationName";
	public final String ACTION_GET_APPVERSION = "getApplicationVersion";
	private static final String ACTION_COPY = "copy";
	private static final String ACTION_PASTE = "paste";

	@Override
	public boolean execute(String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException 
	{
		PackageManager packageManager = this.cordova.getActivity().getPackageManager();
		ApplicationInfo ai;
		CharSequence al;

		final ClipboardManager cb = (ClipboardManager) cordova.getActivity().getSystemService(Context.CLIPBOARD_SERVICE);

		if (action.equals(ACTION_GET_APPVERSION)) {
			try {
				PackageInfo packageInfo = packageManager.getPackageInfo(this.cordova.getActivity().getPackageName(), 0);
				callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK,  packageInfo.versionName));
			}
			catch (Exception e) {
				Log.e("OnymosInitializeManager", "Error occurred calling plugin: " + e.getMessage());
				callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
				return false;
			}
		}
		else if (action.equals(ACTION_GET_APPNAME)) {
			try {						
				String appName = this.cordova.getActivity().getApplicationContext().getPackageName();	
				if (appName != null) {
					PluginResult result = new PluginResult(PluginResult.Status.OK, appName);
					result.setKeepCallback(true);
					callbackContext.sendPluginResult(result);
				}
				else {
					PluginResult result = new PluginResult(PluginResult.Status.ERROR);
					result.setKeepCallback(true);
					callbackContext.sendPluginResult(result);
				}
				return true;
			}
			catch (Exception e) {
				Log.e("OnymosInitializeManager", "Error occurred calling plugin: " + e.getMessage());
				callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
				return false;
			}
		}

		return true;
	}
}