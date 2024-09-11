import type { ViewProps } from "react-native";
import type { SharedViewEvents } from "./SharedViewEvents";
import type { SharedViewEventsInternal } from "./SharedViewEventsInternal";
import type { SharedViewPropsInternal } from "./SharedViewPropsInternal";


/**
 * * The props from "native component" codegen are just stubs, i.e. it defines 
 *   the names of the props, but their types are just dummy placeholders (they
 *   are lies).
 * 
 * * The native components doesn't actually use any of the stuff codegen emits +
 *   generates. 
 * 
 * * I know that this isn't the right way to do things, for now i have decided 
 *   to just manually write the fabric requirements myself in order to properly 
 *   support both fabric + paper in the same codebase. 
 * 
 * * as such the "dummy props definition" in the "native component" codegen 
 *   definition is just a workaround to:
 * 
 *   * 1. suppress the warnings from metro about missing type definitions 
 *        + prop mismatches, and...
 * 
 *   * 2. prevent the codegen "script" from crashing, as it's very picky about 
 *        the types used unfortunately (i.e. there are lots of restrictions)
 * 
 * * Purpose A: This type allows for extracting the "base props" from the
 *   "native component codegen definition" (i.e. it excludes certain props, e.g.
 *   `ViewProps`, shared props, etc).
 * 
 *   * Those "base props" are then remapped at a later step.
 * 
 *   * as such, if the "codegen native component" declares a prop: 
 *     `foo: string`, that type gets extracted, meanwhile all the other props
 *      like `ViewProps` (e.g. `style`, `onLayout`) gets excluded.
 * 
 *    * Then later on in the process, another type allows for the redefinition 
 *      of the "base props" that was returned from this type, so that 
 *      `foo: string` can be remapped to something else (e.g. `foo: FooConfig`).
 * 
 * * Purpose B: There are some props that are "shared" across all 
 *   "native components" in this library (and those that depend on those 
 *   components).
 * 
 *   * i.e. we want a certain set of props/events to be "included" in every 
 *     native component defined in this library (i.e. a "base/shared props")
 * 
 *   * Unfortunately importing types from other files in the "native component 
 *     codegen definition" is a bit fragile (e.g. the codegen script crashes 
 *     sometimes).
 * 
 *   * Because of this, importing a  "base/shared prop" type in the
 *     "native component" codegen definition cannot be done for now, and we must
 *     instead define the "base/shared prop" manually each time. 
 * 
 *   * as such, this type will check if those "set of props/events" are present,
 *     and will produce a type error if they are erroneously omitted.
 * 
 */
export type NativeComponentBaseProps<T extends SharedViewEvents> =
  Omit<T, keyof (ViewProps & SharedViewEvents)>;




//export type MatchesKeys<T, U> = `${T}` extends keyof U ? 123 : false;
// type Foo<T, U = ConvertPropertiesToAny<InternalViewProps>> = keyof T extends keyof U ? U : never; 
// type Foo<T, U> = { [KT in keyof T]: U[KT]  }

// type CommonKeys<S, T> = {
//   [K in keyof S & keyof T]: 
//     [S[K], T[K]] extends [T[K], S[K]] ? K : never
// }[keyof S & keyof T];

// type MustHaveKeys<V, S extends Record<keyof V, any>> = S;


// const a = {  b: 1 }
// const b = { a: 1 }
// export const z: CommonKeys<typeof a, typeof b> = 'a';

// type HasKeys<T> = {
//  [P in keyof T]: any;
// }

// type Bar<T extends Record<keyof InternalViewProps, any>, U> = Omit<U, keyof (
//     ViewProps
//   & SharedViewPropsInternal
//   & SharedViewEvents
//   & SharedViewEventsInternal
// )>;


// type RNIDetachedViewNativeComponentBaseProps = NativeComponentBasePropsInternal<
//   Required<RNIDetachedViewNativeComponentProps>, 
//   RNIDetachedViewNativeComponentProps
// >;

// type Foo<T> = NativeComponentBasePropsInternal<
//   Required<T>, 
//   T
// >;


// type Foo<T> = T extends infer R ? R : any;

// const x: Foo<string>;


// export type NativeComponentBasePropsInternal<
//   T extends Record<keyof InternalViewProps, unknown>,
//   U
// > = Omit<U, keyof (
//     ViewProps
//   & SharedViewPropsInternal
//   & SharedViewEvents
//   & SharedViewEventsInternal
// )>;


// export type NativeComponentBasePropsInternal<
  //T extends MatchesKeys<T, InternalViewProps>
  //T extends Foo<Required<T>>
  //T extends HasKeys<InternalViewProps>
  // T extends MustHaveKeys<T, InternalViewProps>
  //U = Required<T>,
  //T extends Record<keyof InternalViewProps, unknown>,
  //T extends {[K in keyof T]: unknown}
  //T extends {[K in keyof Required<Omit<T, keyof ViewProps>>]: unknown}
//   RawProps,
//   BaseProps = Omit<RawProps, keyof ViewProps>,
//   Props = Omit<RawProps, keyof (
//       ViewProps
//     & SharedViewPropsInternal
//     & SharedViewEvents
//     & SharedViewEventsInternal
//   )>
// > = Required<BaseProps> extends {[K in keyof Required<InternalViewProps>]: unknown} 
//   ? Props 
//   : never;

// Omit<T, keyof (
//   ViewProps
// & SharedViewPropsInternal
// & SharedViewEvents
// & SharedViewEventsInternal
// )>;

// export type NativeComponentBasePropsInternal2<T extends Record<keyof InternalViewProps, unknown>> = 
//  NativeComponentBasePropsInternal<Required<T>, T>;

// export type A<T, U> = keyof T extends keyof U ? any : never;


// export type B<T> = keyof T


type InternalViewProps =
    SharedViewEvents
  & SharedViewEventsInternal
  & SharedViewPropsInternal;


/**
 * Please see `NativeComponentBaseProps` type first.
 * 
 * * This is similar to `NativeComponentBaseProps`, but is meant to be used for
 *   "internal/helper" native components.
 * 
 * * As such it contains more "shared" props that are "internal" only (i.e. 
 *   they are meant to be used by other components, and not exposed the 
 *   consumer of the library).
 * 
 * * This type will produce `Never` if one of the "shared/base internal props" + 
 *   "shared/base props" are erroneously omitted.
 * 
 * * The type definition for this is very weird, because i couldn't get the 
 *   "generic type constraints" to work (like the one in 
 *   `NativeComponentBaseProps` type).
 * 
 * * as such, a conditional type is used instead for checking. 
 * 
 * * Unfortunately w/ this method, the type will not say what props are missing, 
 *   but instead will just produce a `Never` type. very sad.
 */
export type NativeComponentBasePropsInternal<
  RawNativeProps,
  BaseNativeProps = Omit<RawNativeProps, keyof ViewProps>,
  PropsToRemap = Omit<RawNativeProps, keyof ViewProps & InternalViewProps>
> = Required<BaseNativeProps> extends {[K in keyof Required<InternalViewProps>]: unknown} 
  ? PropsToRemap 
  : never;


