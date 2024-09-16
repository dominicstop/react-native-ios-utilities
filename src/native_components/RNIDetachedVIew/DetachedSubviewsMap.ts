import type { OnDidSetViewIDEventPayload } from "../../types/SharedViewEvents";

export type DetachedSubviewEntry = {
  didDetachFromOriginalParent: boolean;
};

export type DetachedSubviewsMap = 
  Record<OnDidSetViewIDEventPayload['viewID'], DetachedSubviewEntry>;

export const DEFAULT_DETACHED_SUBVIEW_ENTRY: DetachedSubviewEntry = Object.freeze({
  didDetachFromOriginalParent: false,
});