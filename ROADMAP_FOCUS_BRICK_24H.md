# Focus Brick — Roadmap 24h (execução contínua)

Objetivo: entregar um app iOS SwiftUI (offline-first, sem login, sem coleta) pronto para TestFlight/App Store em até 24h.

## Regras de execução
- Trabalhar em lotes pequenos com commits frequentes.
- Sempre manter buildável no Xcode.
- Priorizar MVP completo antes de refinamentos visuais.
- Sem backend, sem analytics, sem tracking.

## Backlog executável (ordem)

### Fase 1 — Fundação do projeto
1. ✅ Criar estrutura do projeto iOS SwiftUI (App, Views, ViewModels, Domain, Services).
2. ✅ Definir design tokens azul clean (cores, tipografia, espaçamento).
3. ✅ Criar modelos base (`PomodoroConfig`, `SessionRecord`, `DailySummary`).

### Fase 2 — Core Pomodoro
4. ✅ Implementar motor de timer (focus/break/long break).
5. ✅ Implementar controles (start/pause/resume/reset/skip).
6. ✅ Implementar ciclo longo a cada 4 focos.
7. ✅ Persistir estado de sessão localmente.

### Fase 3 — UX principal
8. ✅ Tela Home com timer grande + progresso circular.
9. ✅ Tela Configurações (25/5 default + custom).
10. ✅ Feedback sonoro/háptico de término de sessão.
11. ✅ Notificações locais para fim de foco/pausa.

### Fase 4 — Histórico e métricas
12. ✅ Histórico últimos 7 dias.
13. ✅ Contadores do dia (sessões, minutos focados).
14. Card de sequência diária (streak simples local).

### Fase 5 — Monetização
15. ✅ Integrar StoreKit (compra única).
16. ✅ Tela paywall simples + estado desbloqueado local.
17. ✅ Toggle de features Pro (temas extras / custom avançado).

### Fase 6 — Qualidade e release
18. ✅ Ajustes finais de UI/UX e acessibilidade básica.
19. Placeholder de ícones/launch screen e textos da App Store.
20. ✅ Checklist de submissão (Privacy: No Data Collected).
21. ✅ README com instruções de build/publicação.

## Critério de pronto (Definition of Done)
- Timer funcional com ciclo completo.
- Histórico local visível.
- Notificação local funcionando.
- Compra única integrada.
- Projeto compilável no Xcode.
- Documentação mínima para publicação.

## Status
- [x] Projeto iniciado
- [x] MVP funcional
- [x] Monetização integrada
- [ ] Release candidate
- [ ] Entrega final
