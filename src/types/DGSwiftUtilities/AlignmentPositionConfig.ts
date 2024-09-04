import type { HorizontalAlignmentPosition } from "./HorizontalAlignmentPosition";
import type { VerticalAlignmentPosition } from "./VerticalAlignmentPosition";


export type AlignmentPositionConfig = {
  horizontalAlignment: HorizontalAlignmentPosition;
  verticalAlignment: VerticalAlignmentPosition;
  preferredHeight?: number;
  preferredWidth?: number;
  marginTop?: number;
  marginBottom?: number;
  marginLeading?: number;
  marginTrailing?: number;
  shouldPreferHeightAnchor?: boolean;
  shouldPreferWidthAnchor?: boolean;
};