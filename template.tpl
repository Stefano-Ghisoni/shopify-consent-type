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
      "text": "⚠️ REQUIREMENT: enable and configure Stape’s Shopify Customer Privacy API tag.",
      "translations": [
        {
          "locale": "it",
          "text": "⚠️ REQUISITO: deve essere attivo e correttamente configurato il tag Shopify Customer Privacy API di Stape."
        }
      ]
    }
  },
  {
    "type": "SELECT",
    "name": "consentCategory",
    "displayName": "Categoria di consenso Shopify",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "essential",
        "displayValue": "Essential (_shopify_essential) — categoria necessaria"
      },
      {
        "value": "analytics",
        "displayValue": "Analytics (_shopify_analytics)"
      },
      {
        "value": "marketing",
        "displayValue": "Marketing (_shopify_marketing)"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "analytics",
    "help": "Restituisce boolean true/false. Se la Customer Privacy API non è disponibile, restituisce undefined. Non confondere Essential con Preferences.",
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

Versione 1.0.0. Solo GTM Web nel contesto principale dello storefront.
Non decifra cookie, non legge cookie HttpOnly, non carica librerie e non aggiorna il Consent Mode.
Analytics/Marketing: permessi effettivi restituiti da Shopify, basati anche su regione e impostazioni del merchant. Non sono la sola scelta esplicita del visitatore.
Essential: true costante per categoria necessaria; non attesta consenso, presenza cookie o funzionamento Shopify.
API assente: undefined; usare nei trigger solo il confronto booleano con true.
Una variabile non genera eventi: per reagire a una modifica consenso serve un evento dataLayer dopo visitorConsentCollected.
Nel sandbox dei Custom Pixel Shopify l'API della finestra principale potrebbe non essere accessibile: occorre un bridge nel pixel basato sulla privacy API del pixel.
Fonti: https://shopify.dev/docs/api/customer-privacy e https://www.shopify.com/legal/cookies

Requisito di installazione: tag Shopify Customer Privacy API di Stape attivo e configurato nello stesso contesto. Attendere caricamento API e sincronizzazione.
Versione repository 1.0.0. Test inclusi: 16 scenari.


