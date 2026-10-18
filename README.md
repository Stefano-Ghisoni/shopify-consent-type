# Shopify Consent Type for Google Tag Manager

A custom variable template for **Google Tag Manager Web containers**. It reads Shopify's effective Analytics and Marketing permissions through the Customer Privacy API and provides an Essential category with a constant `true` result.

## Required Stape tag

**The Shopify Customer Privacy API tag by Stape must be enabled and correctly configured in the same GTM Web context for the setup documented here.**

Install the [Stape tag](https://stape.io/helpdesk/documentation/shopify-customer-privacy-api-tag) and configure its consent source from your CMP or Google Consent Mode. This variable reads Shopify's state; it does not synchronize or change that state.

The underlying technical dependency is a loaded `window.Shopify.customerPrivacy` API. The variable does not inspect whether Stape is installed: an equivalent API integration also works technically. Stape is the required integration for this documented configuration.

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

## Publish on GitHub and submit to the Gallery

The proposed repository name is **shopify-consent-type**, under **stefanoghisoni-adv**, following the owner spelling in the supplied reference project. This repository has not been created or published by this package. Adjust `metadata.yaml` if the actual owner, repository name, or default branch differs.

1. Put the four files at the repository root on `main` and commit them.
2. Copy the real 40-character commit SHA containing the final `template.tpl`.
3. Replace `versions: []` in `metadata.yaml` with:

```yaml
versions:
  - sha: YOUR_ACTUAL_40_CHARACTER_COMMIT_SHA
    changeNotes: "Initial release: Shopify consent category reader with Stape prerequisite and 16 tests."
```

4. Commit the metadata change and push both commits. Reference the earlier template commit, not a fabricated SHA or a commit from another repository.
5. Confirm the documentation URL resolves, enable Issues, run the tests in GTM, and confirm the Gallery terms in the template editor.
6. Submit the public repository through the [Community Template Gallery](https://tagmanager.google.com/gallery/).

`versions: []` is intentional for the GitHub preparation stage. It must be populated before Gallery submission. For later releases, add the new template commit SHA at the top of the versions list and preserve previous release entries.

## Italiano

### Requisito operativo

**Deve essere attivo e correttamente configurato il tag Shopify Customer Privacy API di Stape nello stesso contesto GTM Web.** Il tag sincronizza il consenso della CMP verso Shopify; questa variabile legge lo stato risultante.

Attendi il completamento del caricamento dell'API e della sincronizzazione prima della lettura. La priorità di attivazione, da sola, non garantisce il completamento asincrono. Non usare questa variabile come sorgente di consenso dello stesso tag Stape che deve inizializzare l'API.

### Risultati

- **Essential:** `true` costante per convenzione di categoria necessaria; non è un consenso registrato e non equivale a Preferences.
- **Analytics e Marketing:** booleani restituiti dall'API Shopify. Considerano consenso, regione e impostazioni del negozio.
- **API o metodo assente, categoria non valida o risposta non booleana:** `undefined`.

I cookie non vengono letti o decifrati. La variabile non carica l'API, non concede consenso, non aggiorna il Consent Mode e non genera eventi. Nel sandbox dei Custom Pixel occorre un'integrazione dedicata.

### Test e pubblicazione

I 16 scenari incorporati sono passati nel runner locale con API simulate. Prima della pubblicazione esegui anche tutti i test nell'editor GTM e la verifica in Preview con accettazione, rifiuto e revoca.

I quattro file sono pronti per essere caricati su GitHub. Prima dell'invio alla Gallery devi inserire in `metadata.yaml` lo SHA reale del commit contenente `template.tpl` e verificare l'URL del README. Nessuno SHA è stato inventato.

## References

- [Shopify Customer Privacy API](https://shopify.dev/docs/api/customer-privacy)
- [Stape Shopify Customer Privacy API tag](https://stape.io/helpdesk/documentation/shopify-customer-privacy-api-tag)
- [Google Community Template Gallery submission](https://developers.google.com/tag-platform/tag-manager/templates/gallery)

## License and author

Licensed under Apache License 2.0. See `LICENSE`.

Created and maintained by **Stefano Ghisoni** — [stefanoghisoni.it](https://stefanoghisoni.it), info@stefanoghisoni.it.
