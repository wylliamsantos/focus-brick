# Focus Brick

Pomodoro app iOS (SwiftUI), offline-first, sem login e sem tracking.

## Requisitos
- Xcode 15+
- iOS 17+
- Conta Apple Developer (para TestFlight/App Store)

## Estrutura
- `FocusBrick/App`: entrada do app
- `FocusBrick/Views`: Home, Configurações e Paywall
- `FocusBrick/ViewModels`: lógica do timer e estado de UI
- `FocusBrick/Services`: persistência local, notificações e StoreKit
- `FocusBrick/Domain`: modelos de domínio
- `FocusBrick/Resources`: design tokens

## Como buildar
1. Abra o projeto no Xcode.
2. Selecione um target iOS 17+ (simulador ou device).
3. Build: `Product > Build`.
4. Run: `Product > Run`.

## StoreKit (compra única)
- Product id esperado: `focusbrick.pro.lifetime`
- O app carrega os produtos no launch e expõe estado `isProUnlocked`.
- Fluxos suportados:
  - compra
  - restore purchases
  - desbloqueio local de features Pro

## Notificações locais
- O app solicita permissão de notificação no launch.
- Notifica ao fim de cada fase (foco/pausa).

## Privacidade
- Sem coleta de dados pessoais.
- Sem analytics.
- Sem backend.
- Dados ficam somente no dispositivo (UserDefaults).

## Publicação (resumo)
Use os documentos de release em `docs/`:
- `docs/APP_STORE_CHECKLIST.md`
- `docs/APP_STORE_METADATA_TEMPLATE.md`
- `docs/ASSETS_PLACEHOLDERS.md`

Passos mínimos:
1. Definir bundle id e assinatura.
2. Validar Product ID do StoreKit no App Store Connect.
3. Inserir ícones e launch screen finais.
4. Preencher metadados da App Store.
5. Arquivar e enviar build para TestFlight.
6. Enviar para revisão com privacidade marcada como **No Data Collected**.
