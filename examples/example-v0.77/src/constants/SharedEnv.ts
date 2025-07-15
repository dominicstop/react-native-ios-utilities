export const SHARED_ENV = {
  enableReactNavigation: false,
  enableTabNavigation: false,
  shouldSetAppBackground: false,
  shouldShowCardItems: true,
};

export const IS_USING_NEW_ARCH = 
  (global as any)?.nativeFabricUIManager != null;