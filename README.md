# Shopify Consent Type for Google Tag Manager

A custom variable template for **Google Tag Manager Web containers**. It reads Shopify's effective Analytics and Marketing permissions through the Customer Privacy API and provides an Essential category with a constant `true` result.

## Customer Privacy API requirement and Stape integration

**Shopify's `window.Shopify.customerPrivacy` API must be loaded and its consent state synchronized in the same GTM Web context.**

For the integration documented here, install the [Stape tag](https://stape.io/helpdesk/documentation/shopify-customer-privacy-api-tag) and configure its consent source from your CMP or Google Consent Mode. This variable reads Shopify's state; it does not synchronize or change that state.

Stape is the integration used in this guide, not a mandatory technical dependency. The variable does not inspect whether Stape is installed. Another integration that loads the same API and correctly synchronizes consent also works.

Wait until API loading and consent synchronization have completed before evaluating the variable. A tag firing priority alone does not guarantee completion of asynchronous operations. Use a verified completion event from your integration or evaluate on a later event after confirming readiness. This template does not generate a readiness event.

Avoid circular configuration: do not use this variable as the consent source for the same Stape tag that initializes and synchronizes Shopify consent. The CMP is the source; Stape synchronizes it to Shopify; this variable reads the resulting state.

## Installation

1. Download `template.tpl`.
2. In GTM Web, open **Templates → Variable Templates → New → Import**.
3. Import the file, review its permissions, and save it.
4. Create a user-defined variable with type **Shopify Consent Type**.
5. Select one of the three categories. Create separate variables for multiple categories.

## Configuration and return values

| Dropdown option | Data source | Result |
|---|---|---|
| Essential (`_shopify_essential`) | Explicit necessary-category convention | Always boolean `true` |
| Analytics (`_shopify_analytics`) | `Shopify.customerPrivacy.analyticsProcessingAllowed()` | Boolean `true` or `false`; otherwise `undefined` |
| Marketing (`_shopify_marketing`) | `Shopify.customerPrivacy.marketingAllowed()` | Boolean `true` or `false`; otherwise `undefined` |

Cookie names identify the corresponding categories only. **The template does not read or decrypt these cookies**, and cookie presence is never treated as consent.

Essential does not attest that a cookie exists or that a visitor accepted anything. It is not Shopify's Preferences purpose. The template does not expose Preferences or sale-of-data permission.

Shopify's effective permissions consider recorded consent, visitor region, and merchant settings. They are not equivalent to the visitor's explicit `yes`/`no` choices. Use Shopify's `currentVisitorConsent()` separately when auditing explicit choices.

An unavailable or non-callable API method, unsupported category, or non-boolean API response returns `undefined`. API calls that throw are not caught by this template. Do not interpret `undefined` as consent granted.

## Using the variable

Compare the result to boolean `true` when allowing a tag to run. The variable reads the current state each time it is evaluated and does not cache consent across events.

When consent changes, use your integration to generate a GTM event after synchronization is complete. Shopify publishes `visitorConsentCollected` when consent changes; this variable itself does not register listeners or push data layer events.

The template does not update Google Consent Mode. Configure default states and updates through the CMP/consent integration.

## Permissions and compatibility

The only requested permission is read/execute access to these exact global paths:

- `Shopify.customerPrivacy.analyticsProcessingAllowed`
- `Shopify.customerPrivacy.marketingAllowed`

No global write permissions, cookie access, script injection, network requests, browser storage, or data layer access are requested.

Use this template in the main storefront window. A container inside a Shopify Custom Pixel sandbox may not see the main window's Customer Privacy API. Sandbox integrations need a dedicated privacy bridge; installing this variable alone does not provide one.

## Testing

The template contains **16 isolated test scenarios**, covering allowed and denied states, exact method selection, missing API methods, missing/invalid categories, non-callable methods, non-boolean responses, the Essential convention, and consent changes without caching.

All 16 embedded scenarios passed in a local runner that mocks the two GTM APIs and implements the assertions used by the scenarios. JSON sections, permissions, dropdown values, and English/Italian description lengths were also checked.

This local execution does not certify the GTM sandbox, editor import, live Stape setup, or Gallery acceptance. Before release, import `template.tpl` in GTM, run **Tests → Run all**, and verify the storefront in Preview before consent, after accepting, after rejecting, and after revoking consent.

## Repository files

| File | Purpose |
|---|---|
| `template.tpl` | Variable UI, metadata, sandboxed code, permissions, and tests |
| `metadata.yaml` | Homepage, documentation URL, and Gallery release references |
| `README.md` | Setup, behavior, testing, and publishing instructions |
| `LICENSE` | Apache License 2.0 |

## Repository and Gallery submission

The public repository is [Stefano-Ghisoni/shopify-consent-type](https://github.com/Stefano-Ghisoni/shopify-consent-type), with the project files at the root of the `main` branch.

`metadata.yaml` already contains a release entry referencing commit `705618bcf0ab4ac5e0e0b92b4fac8d0b688a0eba`. Whenever `template.tpl` changes, commit the updated template first, then add its real 40-character commit SHA at the top of the `versions` list and commit the metadata update. Preserve previous release entries.

Before submitting:

1. Ensure the latest release entry references the intended `template.tpl` revision and the documentation URL resolves.
2. Keep Issues enabled, run the tests in GTM, and confirm the Gallery terms in the template editor.
3. Submit the repository URL through the [Community Template Gallery](https://tagmanager.google.com/gallery/).

## Italiano

### Requisito operativo

**L’API `window.Shopify.customerPrivacy` deve essere caricata e il suo stato di consenso sincronizzato nello stesso contesto GTM Web.** Il tag Shopify Customer Privacy API di Stape è l’integrazione descritta in questa guida: sincronizza il consenso della CMP verso Shopify e la variabile legge lo stato risultante. Stape non è un requisito tecnico obbligatorio; funziona anche un’altra integrazione che carichi la stessa API e sincronizzi correttamente il consenso.

Attendi il completamento del caricamento dell'API e della sincronizzazione prima della lettura. La priorità di attivazione, da sola, non garantisce il completamento asincrono. Non usare questa variabile come sorgente di consenso dello stesso tag Stape che deve inizializzare l'API.

### Risultati

- **Essential:** `true` costante per convenzione di categoria necessaria; non è un consenso registrato e non equivale a Preferences.
- **Analytics e Marketing:** booleani restituiti dall'API Shopify. Considerano consenso, regione e impostazioni del negozio.
- **API o metodo assente, categoria non valida o risposta non booleana:** `undefined`.

I cookie non vengono letti o decifrati. La variabile non carica l'API, non concede consenso, non aggiorna il Consent Mode e non genera eventi. Nel sandbox dei Custom Pixel occorre un'integrazione dedicata.

### Test e pubblicazione

I 16 scenari incorporati sono passati nel runner locale con API simulate. Prima della pubblicazione esegui anche tutti i test nell'editor GTM e la verifica in Preview con accettazione, rifiuto e revoca.

La repository pubblica è [Stefano-Ghisoni/shopify-consent-type](https://github.com/Stefano-Ghisoni/shopify-consent-type), sul branch `main`. `metadata.yaml` contiene già una versione. Dopo ogni modifica a `template.tpl`, aggiungi in cima all’elenco lo SHA reale del nuovo commit del template, conservando le versioni precedenti. Prima dell’invio alla Gallery verifica che la versione punti al template da distribuire e che l’URL del README funzioni.

## References

- [Shopify Customer Privacy API](https://shopify.dev/docs/api/customer-privacy)
- [Stape Shopify Customer Privacy API tag](https://stape.io/helpdesk/documentation/shopify-customer-privacy-api-tag)
- [Google Community Template Gallery submission](https://developers.google.com/tag-platform/tag-manager/templates/gallery)

## License and author

Licensed under Apache License 2.0. See `LICENSE`.

Created and maintained by **Stefano Ghisoni** — [stefanoghisoni.it](https://stefanoghisoni.it), info@stefanoghisoni.it.
