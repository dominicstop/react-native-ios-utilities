

export type NotifyOnComponentWillUnmount = (
  reactTag: number,
  isManuallyTriggered: boolean
) => Promise<void>;