# Focus Brick — 24h Roadmap (continuous execution)

Objetivo: entregar um app iOS SwiftUI (offline-first, sem login, sem coleta), com **Widgets** e app complementar **watchOS**, pronto para TestFlight/App Store.

## Execution rules
- Trabalhar em lotes pequenos com commits frequentes.
- Sempre manter buildável no Xcode.
- Priorizar MVP completo antes de refinamentos visuais.
- Sem backend, sem analytics, sem tracking.
- Sempre atualizar este arquivo ao concluir tarefas.

## Executable backlog (order)

### Phase 1 — Project foundation
- [x] 1. Criar estrutura do projeto iOS SwiftUI (App, Views, ViewModels, Domain, Services).
- [x] 2. Definir design tokens azul clean (cores, tipografia, espaçamento).
- [x] 3. Criar modelos base (`PomodoroConfig`, `SessionRecord`, `DailySummary`).

### Phase 2 — Core Pomodoro
- [x] 4. Implementar motor de timer (focus/break/long break).
- [x] 5. Implementar controles (start/pause/resume/reset/skip).
- [x] 6. Implementar ciclo longo a cada 4 focos.
- [x] 7. Persistir estado de sessão localmente.

### Phase 3 — UX principal iOS
- [x] 8. Tela Home com timer grande + progresso circular.
- [x] 9. Tela Settings (25/5 default + custom).
- [x] 10. Feedback sonoro/háptico de término de sessão.
- [x] 11. Local notifications para fim de foco/pausa.

### Phase 4 — Histórico e métricas
- [x] 12. Histórico últimos 7 dias.
- [x] 13. Contadores do dia (sessões, minutos focados).
- [x] 14. Card de sequência diária (streak simples local).

### Phase 5 — Widgets (iOS)
- [x] 15. Criar extensão WidgetKit (small/medium).
- [x] 16. Widget “Sessão Atual” (fase, tempo restante, estado).
- [x] 17. Widget “Resumo do Dia” (sessões + minutos focados).
- [x] 18. Deep link do widget para abrir app na tela correta.

### Phase 6 — watchOS companion
- [x] 19. Criar target watchOS (SwiftUI).
- [x] 20. Tela principal no watch (timer + start/pause/reset).
- [x] 21. Sincronizar estado essencial iPhone <-> Watch (WatchConnectivity).
- [x] 22. Complicações básicas (estado da sessão/tempo restante).

### Phase 7 — Monetização
- [x] 23. Integrar StoreKit (one-time purchase).
- [x] 24. Tela paywall simples + estado desbloqueado local.
- [x] 25. Toggle de features Pro (temas extras / custom avançado).

### Phase 8 — Qualidade e release
- [x] 26. Ajustes finais de UI/UX e acessibilidade básica.
- [x] 27. Ícone/launch screen e textos da App Store.
- [x] 28. Checklist de submissão (Privacy: No Data Collected).
- [x] 29. README com instruções de build/publicação.

## Definition of done (Definition of Done)
- Timer funcional com ciclo completo.
- Histórico local visível.
- Notificação local funcionando.
- Widget funcional (sessão e resumo).
- watchOS funcional com timer básico.
- Compra única integrada.
- Projeto compilável no Xcode.
- Documentação mínima para publicação.

## Status macro
- [x] Base e core inicial
- [x] MVP iOS completo
- [x] Widgets completos
- [x] watchOS completo
- [x] Monetização integrada
- [x] Release candidate
- [x] Entrega final
