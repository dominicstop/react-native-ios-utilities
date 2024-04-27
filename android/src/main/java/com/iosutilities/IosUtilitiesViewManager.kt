package com.iosutilities

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp

@ReactModule(name = IosUtilitiesViewManager.NAME)
class IosUtilitiesViewManager :
  IosUtilitiesViewManagerSpec<IosUtilitiesView>() {
  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): IosUtilitiesView {
    return IosUtilitiesView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: IosUtilitiesView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "IosUtilitiesView"
  }
}
