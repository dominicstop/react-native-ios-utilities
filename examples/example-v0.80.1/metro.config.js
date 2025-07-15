const { getDefaultConfig, mergeConfig } = require('@react-native/metro-config');
const { getConfig } = require('react-native-builder-bob/metro-config');

const path = require('path');
const escape = require('escape-string-regexp');
const exclusionList = require('metro-config/src/defaults/exclusionList');

const rootLibraryPackage = require('../../package.json');

const coreExamplePackage = require('../example-core/package.json');
const coreExamplePath = path.resolve(__dirname, '../example-core');

const root = path.resolve(__dirname, '../..');

const modules = Object.keys({ ...rootLibraryPackage.peerDependencies });
modules.push(coreExamplePackage.name);

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('@react-native/metro-config').MetroConfig}
 */
const config = {
  watchFolders: [
    root, 
    coreExamplePath
  ], 
  // We need to make sure that only one version is loaded for peerDependencies
  // So we block them at the root, and alias them to the versions in example's node_modules
  resolver: {
    blacklistRE: exclusionList(
      modules.map(
        (m) =>
          new RegExp(`^${escape(path.join(root, 'node_modules', m))}\\/.*$`)
      )
    ),

    extraNodeModules: (() => {
     const extraNodeModules = modules.reduce((acc, name) => {
        acc[name] = path.join(__dirname, 'node_modules', name);
        return acc;
      }, {});

      return {
        ...extraNodeModules,
        'react-native': path.join(__dirname, 'node_modules/react-native'),
      };
    })(),
  },

  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
  },
};

const defaultConfig = getConfig(getDefaultConfig(__dirname), {
  root,
  pkg: rootLibraryPackage,
  project: __dirname,
});

/**
 * Metro configuration
 * https://facebook.github.io/metro/docs/configuration
 *
 * @type {import('metro-config').MetroConfig}
 */
module.exports = mergeConfig(defaultConfig, config);

// const { getDefaultConfig, mergeConfig } = require('@react-native/metro-config');
// module.exports = mergeConfig(getDefaultConfig(__dirname), config);