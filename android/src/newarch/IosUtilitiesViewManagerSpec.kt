package com.iosutilities

import android.view.View

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.IosUtilitiesViewManagerDelegate
import com.facebook.react.viewmanagers.IosUtilitiesViewManagerInterface

abstract class IosUtilitiesViewManagerSpec<T : View> : SimpleViewManager<T>(), IosUtilitiesViewManagerInterface<T> {
  private val mDelegate: ViewManagerDelegate<T>

  init {
    mDelegate = IosUtilitiesViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<T>? {
    return mDelegate
  }
}
