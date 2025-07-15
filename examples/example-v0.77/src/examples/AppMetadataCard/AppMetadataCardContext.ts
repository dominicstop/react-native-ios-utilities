import * as React from 'react';

export type AppMetadataCardContextPayload = {
  metadataOverrideData: Record<string, unknown>;
};

export const AppMetadataCardContext = 
  React.createContext<AppMetadataCardContextPayload | undefined>(undefined);

export const AppMetadataCardContextProvider = AppMetadataCardContext.Provider;
