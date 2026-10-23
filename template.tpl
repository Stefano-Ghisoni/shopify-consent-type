___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Shopify Consent Type",
  "description": {
    "text": "Reads Shopify Analytics and Marketing permissions via the Customer Privacy API. Essential always returns true. Returns undefined if the API is unavailable. Does not decrypt cookies.",
    "translations": [
      {
        "locale": "it",
        "text": "Legge i permessi Analytics e Marketing tramite la Customer Privacy API Shopify. Essential restituisce sempre true. Restituisce undefined se l’API non è disponibile. Non decifra cookie."
      }
    ]
  },
  "containerContexts": [
    "WEB"
  ],
  "metadata": {
    "author": {
      "name": "stefano-ghisoni",
      "url": "https://stefanoghisoni.it",
      "email": "info@stefanoghisoni.it"
    }
  },
  "categories": [
    "UTILITY",
    "TAG_MANAGEMENT"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "LABEL",
    "name": "stapeRequirement",
    "displayName": {
      "text": "⚠️ REQUIREMENT: load Shopify’s Customer Privacy API and synchronize consent in the same GTM Web context. This guide uses <a href=\"https://tagmanager.google.com/gallery/#/owners/stape-io/templates/shopify-customer-privacy-tag\" target=\"_blank\">Stape’s Shopify Customer Privacy API tag</a>; another compatible API integration also works. Wait until API loading and consent synchronization are complete before reading this variable.",
      "translations": [
        {
          "locale": "it",
          "text": "⚠️ REQUISITO: carica la Customer Privacy API di Shopify e sincronizza il consenso nello stesso contesto GTM Web. Questa guida usa il <a href=\"https://tagmanager.google.com/gallery/#/owners/stape-io/templates/shopify-customer-privacy-tag\" target=\"_blank\">tag Shopify Customer Privacy API di Stape</a>; funziona anche un’altra integrazione API compatibile. Attendi il completamento del caricamento dell’API e della sincronizzazione del consenso prima di leggere questa variabile."
        }
      ]
    }
  },
  {
    "type": "SELECT",
    "name": "consentCategory",
    "displayName": {
      "text": "Shopify consent category",
      "translations": [
        {
          "locale": "it",
          "text": "Categoria di consenso Shopify"
        }
      ]
    },
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "essential",
        "displayValue": {
          "text": "Essential (_shopify_essential) — always true",
          "translations": [
            {
              "locale": "it",
              "text": "Essential (_shopify_essential) — sempre true"
            }
          ]
        }
      },
      {
        "value": "analytics",
        "displayValue": {
          "text": "Analytics (_shopify_analytics)",
          "translations": [
            {
              "locale": "it",
              "text": "Analisi (_shopify_analytics)"
            }
          ]
        }
      },
      {
        "value": "marketing",
        "displayValue": {
          "text": "Marketing (_shopify_marketing)",
          "translations": [
            {
              "locale": "it",
              "text": "Marketing (_shopify_marketing)"
            }
          ]
        }
      }
    ],
    "simpleValueType": true,
    "defaultValue": "analytics",
    "help": {
      "text": "Analytics and Marketing return boolean true/false from Shopify's API, or undefined if unavailable. Essential always returns true by convention; it does not read consent or correspond to Preferences. Cookies are not read.",
      "translations": [
        {
          "locale": "it",
          "text": "Analisi e Marketing restituiscono true/false dall’API Shopify oppure undefined se non disponibile. Essential restituisce sempre true per convenzione: non legge un consenso e non equivale a Preferences. I cookie non vengono letti."
        }
      ]
    },
    "alwaysInSummary": true
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const copyFromWindow = require('copyFromWindow');
const callInWindow = require('callInWindow');

// Categoria necessaria: convenzione esplicita, non lettura del cookie.
if (data.consentCategory === 'essential') return true;

let method;
if (data.consentCategory === 'analytics') {
  method = 'Shopify.customerPrivacy.analyticsProcessingAllowed';
} else if (data.consentCategory === 'marketing') {
  method = 'Shopify.customerPrivacy.marketingAllowed';
} else {
  return undefined;
}

// Nessun fallback basato sulla presenza dei cookie.
if (typeof copyFromWindow(method) !== 'function') return undefined;
const result = callInWindow(method);
if (result === true) return true;
if (result === false) return false;
return undefined;


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "Shopify.customerPrivacy.analyticsProcessingAllowed"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "Shopify.customerPrivacy.marketingAllowed"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: analytics true
  code: |-
    mock('copyFromWindow', function(path) { return function() {}; });
    mock('callInWindow', function(path) {
      assertThat(path).isEqualTo('Shopify.customerPrivacy.analyticsProcessingAllowed');
      return true;
    });
    assertThat(runCode({consentCategory: 'analytics'})).isEqualTo(true);
- name: analytics false
  code: |-
    mock('copyFromWindow', function(path) { return function() {}; });
    mock('callInWindow', function(path) {
      assertThat(path).isEqualTo('Shopify.customerPrivacy.analyticsProcessingAllowed');
      return false;
    });
    assertThat(runCode({consentCategory: 'analytics'})).isEqualTo(false);
- name: marketing true
  code: |-
    mock('copyFromWindow', function(path) { return function() {}; });
    mock('callInWindow', function(path) {
      assertThat(path).isEqualTo('Shopify.customerPrivacy.marketingAllowed');
      return true;
    });
    assertThat(runCode({consentCategory: 'marketing'})).isEqualTo(true);
- name: marketing false
  code: |-
    mock('copyFromWindow', function(path) { return function() {}; });
    mock('callInWindow', function(path) {
      assertThat(path).isEqualTo('Shopify.customerPrivacy.marketingAllowed');
      return false;
    });
    assertThat(runCode({consentCategory: 'marketing'})).isEqualTo(false);
- name: API assente
  code: |-
    mock('copyFromWindow', function() { return undefined; });
    assertThat(runCode({consentCategory: 'analytics'})).isUndefined();
    assertApi('callInWindow').wasNotCalled();
- name: Essential convenzione
  code: |-
    assertThat(runCode({consentCategory: 'essential'})).isEqualTo(true);
    assertApi('callInWindow').wasNotCalled();
- name: Categoria invalida
  code: |-
    assertThat(runCode({consentCategory: 'invalid'})).isUndefined();
    assertApi('callInWindow').wasNotCalled();
- name: Risposta inattesa
  code: |-
    mock('copyFromWindow', function() { return function() {}; });
    mock('callInWindow', function() { return 'true'; });
    assertThat(runCode({consentCategory: 'marketing'})).isUndefined();
- name: Null response
  code: |-
    mock('copyFromWindow', function() { return function() {}; });
    mock('callInWindow', function() { return null; });
    assertThat(runCode({consentCategory: 'analytics'})).isUndefined();
- name: Undefined response
  code: |-
    mock('copyFromWindow', function() { return function() {}; });
    mock('callInWindow', function() { return undefined; });
    assertThat(runCode({consentCategory: 'analytics'})).isUndefined();
- name: Numeric response
  code: |-
    mock('copyFromWindow', function() { return function() {}; });
    mock('callInWindow', function() { return 1; });
    assertThat(runCode({consentCategory: 'analytics'})).isUndefined();
- name: Object response
  code: |-
    mock('copyFromWindow', function() { return function() {}; });
    mock('callInWindow', function() { return {}; });
    assertThat(runCode({consentCategory: 'analytics'})).isUndefined();
- name: Marketing API missing
  code: |-
    mock('copyFromWindow', function() { return undefined; });
    assertThat(runCode({consentCategory: 'marketing'})).isUndefined();
    assertApi('callInWindow').wasNotCalled();
- name: Missing category
  code: |-
    assertThat(runCode({})).isUndefined();
    assertApi('callInWindow').wasNotCalled();
    assertApi('copyFromWindow').wasNotCalled();
- name: Non callable method
  code: |-
    mock('copyFromWindow', function() { return true; });
    assertThat(runCode({consentCategory: 'marketing'})).isUndefined();
    assertApi('callInWindow').wasNotCalled();
- name: Reads updated consent without caching
  code: |-
    let allowed = false;
    mock('copyFromWindow', function() { return function() {}; });
    mock('callInWindow', function() { return allowed; });
    assertThat(runCode({consentCategory: 'marketing'})).isEqualTo(false);
    allowed = true;
    assertThat(runCode({consentCategory: 'marketing'})).isEqualTo(true);
    allowed = false;
    assertThat(runCode({consentCategory: 'marketing'})).isEqualTo(false);


___NOTES___

Version 1.0.0.

Compatibility:
- Google Tag Manager Web containers in the main storefront window.
- Shopify Custom Pixel sandboxes may not expose the main window's Customer Privacy API.
- Sandbox integrations require a dedicated privacy bridge.

Installation requirement:
- Load window.Shopify.customerPrivacy and synchronize consent in the same GTM Web context.
- This guide uses Stape's Shopify Customer Privacy API tag; another integration that loads the same API and correctly synchronizes consent also works.
- The variable does not check whether Stape is installed.
- Wait until API loading and consent synchronization are complete before evaluating the variable.
- Tag firing priority alone does not guarantee completion of asynchronous operations.
- Do not use this variable as the consent source for the same Stape tag that initializes and synchronizes Shopify consent.

Behavior:
- Analytics and Marketing return effective permissions from Shopify's Customer Privacy API.
- Effective permissions consider recorded consent, visitor region, and merchant settings.
- Effective permissions are not equivalent to the visitor's explicit consent choices.
- Essential always returns true by convention.
- Essential does not attest consent, cookie presence, or Shopify functionality.
- Essential does not correspond to Shopify's Preferences purpose.
- Missing or non-callable API methods, invalid categories, and non-boolean responses return undefined.
- Exceptions thrown by API methods are not caught.
- Cookie presence is never interpreted as consent.

Scope:
- Does not read, decrypt, or modify cookies.
- Does not load the Customer Privacy API.
- Does not grant or update consent.
- Does not update Google Consent Mode.
- Does not generate data layer events or register event listeners.
- Does not cache consent across evaluations.

Consent changes:
- Use a GTM event generated after consent synchronization to evaluate the updated state.
- Shopify publishes visitorConsentCollected when consent changes.
- This variable does not automatically subscribe to that event.
- Require a boolean true result when using this variable to allow a tag to fire.

Tests:
- Includes 16 scenarios covering granted and denied permissions, unavailable methods,
  invalid categories, non-boolean responses, and consent changes without caching.

References:
https://shopify.dev/docs/api/customer-privacy
https://www.shopify.com/legal/cookies
https://tagmanager.google.com/gallery/#/owners/stape-io/templates/shopify-customer-privacy-tag
