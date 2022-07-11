# appd-ionic-capacitor-plugin

AppDynamics Mobile EUM Agent Plugin

## Install

1. Download the repository this README is in. https://github.com/jeremydavis02/appd-ionic-capacitor-plugin
2. In the downloaded repos main folder run 'npm install'
3. Then run 'npm run build'
4. In your ionic application we then run 'npm install /path/to/plugin/repo'
5. In your ionic application then run 'npx cap sync'

## API

<docgen-index>

- [`echo(...)`](#echo)
- [`startTimer(...)`](#starttimer)
- [`stopTimer(...)`](#stoptimer)
- [`reportMetricWithName(...)`](#reportmetricwithname)
- [`leaveBreadcrumb(...)`](#leavebreadcrumb)
- [`setUserData(...)`](#setuserdata)
- [`removeUserData(...)`](#removeuserdata)
- [`beginCall(...)`](#begincall)
- [`endCall(...)`](#endcall)
- [`beginHttpRequest(...)`](#beginhttprequest)
- [`reportDone(...)`](#reportdone)
- [`withResponseCode(...)`](#withresponsecode)
- [`withResponseContentLength(...)`](#withresponsecontentlength)
- [`withRequestContentLength(...)`](#withrequestcontentlength)
- [`withResponseHeaderFields(...)`](#withresponseheaderfields)
- [`withRequestHeaderFields(...)`](#withrequestheaderfields)
- [`withInstrumentationSource(...)`](#withinstrumentationsource)
- [`withErrorMessage(...)`](#witherrormessage)
- [`getCorrelationHeaders()`](#getcorrelationheaders)
- [`startNextSession()`](#startnextsession)
- [`unblockScreenshots()`](#unblockscreenshots)
- [`blockScreenshots()`](#blockscreenshots)
- [`screenshotsBlocked()`](#screenshotsblocked)
- [`takeScreenshot()`](#takescreenshot)
- [`startSessionFrame(...)`](#startsessionframe)
- [`endSessionFrame(...)`](#endsessionframe)
- [`updateSessionFrameName(...)`](#updatesessionframename)
- [`getVersion()`](#getversion)
- [`clear()`](#clear)
- [Interfaces](#interfaces)

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

---

### startTimer(...)

```typescript
startTimer(options: { name: string; }) => void
```

| Param         | Type                           |
| ------------- | ------------------------------ |
| **`options`** | <code>{ name: string; }</code> |

---

### stopTimer(...)

```typescript
stopTimer(options: { name: string; }) => void
```

| Param         | Type                           |
| ------------- | ------------------------------ |
| **`options`** | <code>{ name: string; }</code> |

---

### reportMetricWithName(...)

```typescript
reportMetricWithName(options: { name: string; value: number; }) => void
```

| Param         | Type                                          |
| ------------- | --------------------------------------------- |
| **`options`** | <code>{ name: string; value: number; }</code> |

---

### leaveBreadcrumb(...)

```typescript
leaveBreadcrumb(options: { name: string; }) => void
```

| Param         | Type                           |
| ------------- | ------------------------------ |
| **`options`** | <code>{ name: string; }</code> |

---

### setUserData(...)

```typescript
setUserData(options: { key: string; value: string; }) => void
```

| Param         | Type                                         |
| ------------- | -------------------------------------------- |
| **`options`** | <code>{ key: string; value: string; }</code> |

---

### removeUserData(...)

```typescript
removeUserData(options: { key: string; }) => void
```

| Param         | Type                          |
| ------------- | ----------------------------- |
| **`options`** | <code>{ key: string; }</code> |

---

### beginCall(...)

```typescript
beginCall(options: { className: string; methodName: string; withArguments: []; }) => Promise<{ call_tracker: string; }>
```

| Param         | Type                                                                       |
| ------------- | -------------------------------------------------------------------------- |
| **`options`** | <code>{ className: string; methodName: string; withArguments: []; }</code> |

**Returns:** <code>Promise&lt;{ call_tracker: string; }&gt;</code>

---

### endCall(...)

```typescript
endCall(options: { call_tracker: string; }) => void
```

| Param         | Type                                   |
| ------------- | -------------------------------------- |
| **`options`** | <code>{ call_tracker: string; }</code> |

---

### beginHttpRequest(...)

```typescript
beginHttpRequest(options: { url: string; }) => Promise<{ http_tracker: string; }>
```

| Param         | Type                          |
| ------------- | ----------------------------- |
| **`options`** | <code>{ url: string; }</code> |

**Returns:** <code>Promise&lt;{ http_tracker: string; }&gt;</code>

---

### reportDone(...)

```typescript
reportDone(options: { http_tracker: string; }) => void
```

| Param         | Type                                   |
| ------------- | -------------------------------------- |
| **`options`** | <code>{ http_tracker: string; }</code> |

---

### withResponseCode(...)

```typescript
withResponseCode(options: { http_tracker: string; status_code: string; }) => void
```

| Param         | Type                                                        |
| ------------- | ----------------------------------------------------------- |
| **`options`** | <code>{ http_tracker: string; status_code: string; }</code> |

---

### withResponseContentLength(...)

```typescript
withResponseContentLength(options: { http_tracker: string; content_length: number; }) => void
```

| Param         | Type                                                           |
| ------------- | -------------------------------------------------------------- |
| **`options`** | <code>{ http_tracker: string; content_length: number; }</code> |

---

### withRequestContentLength(...)

```typescript
withRequestContentLength(options: { http_tracker: string; content_length: number; }) => void
```

| Param         | Type                                                           |
| ------------- | -------------------------------------------------------------- |
| **`options`** | <code>{ http_tracker: string; content_length: number; }</code> |

---

### withResponseHeaderFields(...)

```typescript
withResponseHeaderFields(options: { http_tracker: string; http_headers: Map<string, string>; }) => void
```

| Param         | Type                                                                                               |
| ------------- | -------------------------------------------------------------------------------------------------- |
| **`options`** | <code>{ http_tracker: string; http_headers: <a href="#map">Map</a>&lt;string, string&gt;; }</code> |

---

### withRequestHeaderFields(...)

```typescript
withRequestHeaderFields(options: { http_tracker: string; http_headers: Map<string, string>; }) => void
```

| Param         | Type                                                                                               |
| ------------- | -------------------------------------------------------------------------------------------------- |
| **`options`** | <code>{ http_tracker: string; http_headers: <a href="#map">Map</a>&lt;string, string&gt;; }</code> |

---

### withInstrumentationSource(...)

```typescript
withInstrumentationSource(options: { http_tracker: string; information_source: string; }) => void
```

| Param         | Type                                                               |
| ------------- | ------------------------------------------------------------------ |
| **`options`** | <code>{ http_tracker: string; information_source: string; }</code> |

---

### withErrorMessage(...)

```typescript
withErrorMessage(options: { http_tracker: string; error_message: string; }) => void
```

| Param         | Type                                                          |
| ------------- | ------------------------------------------------------------- |
| **`options`** | <code>{ http_tracker: string; error_message: string; }</code> |

---

### getCorrelationHeaders()

```typescript
getCorrelationHeaders() => Promise<{ headers: Map<string, string>; }>
```

**Returns:** <code>Promise&lt;{ headers: <a href="#map">Map</a>&lt;string, string&gt;; }&gt;</code>

---

### startNextSession()

```typescript
startNextSession() => void
```

---

### unblockScreenshots()

```typescript
unblockScreenshots() => void
```

---

### blockScreenshots()

```typescript
blockScreenshots() => void
```

---

### screenshotsBlocked()

```typescript
screenshotsBlocked() => Promise<{ screenshots_blocked: boolean; }>
```

**Returns:** <code>Promise&lt;{ screenshots_blocked: boolean; }&gt;</code>

---

### takeScreenshot()

```typescript
takeScreenshot() => void
```

---

### startSessionFrame(...)

```typescript
startSessionFrame(options: { session_frame_name: string; }) => Promise<{ session_frame: string; }>
```

| Param         | Type                                         |
| ------------- | -------------------------------------------- |
| **`options`** | <code>{ session_frame_name: string; }</code> |

**Returns:** <code>Promise&lt;{ session_frame: string; }&gt;</code>

---

### endSessionFrame(...)

```typescript
endSessionFrame(options: { session_frame: string; }) => void
```

| Param         | Type                                    |
| ------------- | --------------------------------------- |
| **`options`** | <code>{ session_frame: string; }</code> |

---

### updateSessionFrameName(...)

```typescript
updateSessionFrameName(options: { session_frame_name: string; session_frame: string; }) => Promise<{ session_frame: string; }>
```

| Param         | Type                                                                |
| ------------- | ------------------------------------------------------------------- |
| **`options`** | <code>{ session_frame_name: string; session_frame: string; }</code> |

**Returns:** <code>Promise&lt;{ session_frame: string; }&gt;</code>

---

### getVersion()

```typescript
getVersion() => Promise<{ version: string; }>
```

**Returns:** <code>Promise&lt;{ version: string; }&gt;</code>

---

### clear()

```typescript
clear() => void
```

---

### Interfaces

#### Map

| Prop       | Type                |
| ---------- | ------------------- |
| **`size`** | <code>number</code> |

| Method      | Signature                                                                                                      |
| ----------- | -------------------------------------------------------------------------------------------------------------- |
| **clear**   | () =&gt; void                                                                                                  |
| **delete**  | (key: K) =&gt; boolean                                                                                         |
| **forEach** | (callbackfn: (value: V, key: K, map: <a href="#map">Map</a>&lt;K, V&gt;) =&gt; void, thisArg?: any) =&gt; void |
| **get**     | (key: K) =&gt; V \| undefined                                                                                  |
| **has**     | (key: K) =&gt; boolean                                                                                         |
| **set**     | (key: K, value: V) =&gt; this                                                                                  |

</docgen-api>
