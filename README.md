# appd-ionic-capacitor-plugin

AppDynamics Mobile EUM Agent

## Install

```bash
npm install appd-ionic-capacitor-plugin
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`getVersion()`](#getversion)
* [`onReset()`](#onreset)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### getVersion()

```typescript
getVersion() => Promise<{ version: string; }>
```

**Returns:** <code>Promise&lt;{ version: string; }&gt;</code>

--------------------


### onReset()

```typescript
onReset() => void
```

--------------------

</docgen-api>
