# Focus Brick

Pomodoro app iOS (SwiftUI), offline-first, sem login e sem tracking.

## Requisitos
- Xcode 15+
- iOS 17+
- Conta Apple Developer (para TestFlight/App Store)

## Estrutura
- `FocusBrick/App`: entrada do app
- `FocusBrick/Views`: Home, Settings e Paywall
- `FocusBrick/ViewModels`: timer logic and UI state
- `FocusBrick/Services`: local persistence, notifications, and StoreKit
- `FocusBrick/Domain`: domain models
- `FocusBrick/Resources`: design tokens

## Como buildar
1. Abra o projeto no Xcode.
2. Selecione o scheme do app iOS e um target iOS 17+ (simulador ou device).
3. Build: `Product > Build`.
4. Run: `Product > Run`.

### Build de Widgets
1. Selecione o scheme que inclui a extensão `FocusBrickWidgets`.
2. Rode no simulador iOS.
3. Adicione o widget small/medium na Home Screen e valide deep links para:
   - current session
   - daily summary

### Build de watchOS
1. Selecione o scheme do app watchOS companion.
2. Rode em simulador Apple Watch (pareado a iPhone).
3. Validar start/pause/reset + essential sync with iPhone.

## StoreKit (one-time purchase)
- Product id esperado: `focusbrick.pro.lifetime`
- O app carrega os produtos no launch e expõe estado `isProUnlocked`.
- Fluxos suportados:
  - compra
  - restore purchases
  - desbloqueio local de features Pro

## Local notifications
- O app solicita permissão de notificação no launch.
- Notifica ao fim de cada fase (foco/pausa).

## Privacidade
- Sem coleta de dados pessoais.
- Sem analytics.
- Sem backend.
- Dados ficam somente no dispositivo (UserDefaults).

## Release (summary)
Use os documentos de release em `docs/`:
- `docs/APP_STORE_CHECKLIST.md`
- `docs/APP_STORE_METADATA_TEMPLATE.md`
- `docs/ASSETS_PLACEHOLDERS.md`

Minimum steps:
1. Definir bundle id e assinatura.
2. Validar Product ID do StoreKit no App Store Connect.
3. Add final icons and launch screen.
4. Preencher metadados da App Store.
5. Arquivar e enviar build para TestFlight.
6. Submit for review with privacy set to **No Data Collected**.
