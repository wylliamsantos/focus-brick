# Focus Brick — Roadmap 24h (execução contínua)

Objetivo: entregar um app iOS SwiftUI (offline-first, sem login, sem coleta), com **Widgets** e app complementar **watchOS**, pronto para TestFlight/App Store.

## Regras de execução
- Trabalhar em lotes pequenos com commits frequentes.
- Sempre manter buildável no Xcode.
- Priorizar MVP completo antes de refinamentos visuais.
- Sem backend, sem analytics, sem tracking.
- Sempre atualizar este arquivo ao concluir tarefas.

## Backlog executável (ordem)

### Fase 1 — Fundação do projeto
- [x] 1. Criar estrutura do projeto iOS SwiftUI (App, Views, ViewModels, Domain, Services).
- [x] 2. Definir design tokens azul clean (cores, tipografia, espaçamento).
- [x] 3. Criar modelos base (`PomodoroConfig`, `SessionRecord`, `DailySummary`).

### Fase 2 — Core Pomodoro
- [x] 4. Implementar motor de timer (focus/break/long break).
- [x] 5. Implementar controles (start/pause/resume/reset/skip).
- [x] 6. Implementar ciclo longo a cada 4 focos.
- [x] 7. Persistir estado de sessão localmente.

### Fase 3 — UX principal iOS
- [x] 8. Tela Home com timer grande + progresso circular.
- [x] 9. Tela Configurações (25/5 default + custom).
- [x] 10. Feedback sonoro/háptico de término de sessão.
- [x] 11. Notificações locais para fim de foco/pausa.

### Fase 4 — Histórico e métricas
- [x] 12. Histórico últimos 7 dias.
- [x] 13. Contadores do dia (sessões, minutos focados).
- [x] 14. Card de sequência diária (streak simples local).

### Fase 5 — Widgets (iOS)
- [x] 15. Criar extensão WidgetKit (small/medium).
- [x] 16. Widget “Sessão Atual” (fase, tempo restante, estado).
- [x] 17. Widget “Resumo do Dia” (sessões + minutos focados).
- [x] 18. Deep link do widget para abrir app na tela correta.

### Fase 6 — watchOS companion
- [ ] 19. Criar target watchOS (SwiftUI).
- [ ] 20. Tela principal no watch (timer + start/pause/reset).
- [ ] 21. Sincronizar estado essencial iPhone <-> Watch (WatchConnectivity).
- [ ] 22. Complicações básicas (estado da sessão/tempo restante).

### Fase 7 — Monetização
- [ ] 23. Integrar StoreKit (compra única).
- [ ] 24. Tela paywall simples + estado desbloqueado local.
- [ ] 25. Toggle de features Pro (temas extras / custom avançado).

### Fase 8 — Qualidade e release
- [ ] 26. Ajustes finais de UI/UX e acessibilidade básica.
- [ ] 27. Ícone/launch screen e textos da App Store.
- [ ] 28. Checklist de submissão (Privacy: No Data Collected).
- [ ] 29. README com instruções de build/publicação.

## Critério de pronto (Definition of Done)
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
- [ ] MVP iOS completo
- [ ] Widgets completos
- [ ] watchOS completo
- [ ] Monetização integrada
- [ ] Release candidate
- [ ] Entrega final
