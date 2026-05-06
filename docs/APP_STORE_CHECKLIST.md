# Focus Brick — Submission Checklist

## 1) Projeto e assinatura
- [ ] Bundle Identifier definido
- [ ] Team/Signing configurado
- [ ] Version e Build Number incrementados
- [ ] Capability de In-App Purchase habilitada

## 2) One-time Purchase Product
- [ ] Product ID `focusbrick.pro.lifetime` criado no App Store Connect
- [ ] Price and availability defined
- [ ] Screenshot/review notes de IAP preparados (se necessário)

## 3) Qualidade funcional
- [ ] Timer completo (focus/short break/long break)
- [ ] Start/pause/resume/reset/skip funcionando
- [ ] Persistência de estado após fechar/reabrir app
- [ ] 7-day history and daily counters display correctly
- [ ] Local notifications at session end
- [ ] Widgets small/medium abrindo deep link correto
- [ ] Watch app com start/pause/reset e sync essencial
- [ ] Compra e restore funcionando em ambiente de teste

## 4) Privacidade (App Privacy)
- [ ] Marcar como **No Data Collected**
- [ ] Confirmar ausência de SDKs de tracking/analytics
- [ ] Política de privacidade (se exigida pelo fluxo da conta)

## 5) Metadados App Store
- [ ] Nome do app
- [ ] Subtitle
- [ ] Short description/longa
- [ ] Keywords
- [ ] URL de suporte
- [ ] Categoria
- [ ] Age rating

## 6) Assets visuais
- [ ] App icon final (todos os tamanhos)
- [ ] Launch screen validada
- [ ] Screenshots iPhone (mín. exigido)

## 7) Distribution
- [ ] Archive no Xcode
- [ ] Upload para TestFlight
- [ ] Smoke test via TestFlight
- [ ] Submit for Review
