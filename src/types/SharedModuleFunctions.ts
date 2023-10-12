

export type NotifyComponentWillUnmount = (
  reactTag: number,
  isManuallyTriggered: boolean
) => Promise<void>;