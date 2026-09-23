# World-tour — Roadmap Modulare: Sezione 13

- File di origine: `docs/roadmap.md`
- Titolo: Registro Storico delle Suite di Test Convalidate
- Priorità Operativa: P13 - Qualità & Verifica

---

## 13. REGISTRO STORICO DELLE SUITE DI TEST CONVALIDATE (19/19 TEST SUITE)

A testimonianza della solidità tecnica delle fondamenta attuali, tutte le seguenti 19 suite di test automatizzati vengono eseguite in modalità headless con 0 errori:
1. `tests/test_formulas.gd`: 24 test unitari su curve XP, formule qualità brani, concert score e bilanciamento.
2. `tests/test_time_system.gd`: 15 test su orologio giornaliero, fasce orarie e stati IDLE/BUSY/PAUSED.
3. `tests/test_end_day_system.gd`: 12 test su ciclo di mezzanotte, spese fisse e riposo notturno.
4. `tests/test_save_manager.gd`: 16 test su serializzazione, persistenza JSON atomica e integrità salvataggi.
5. `tests/test_localization_manager.gd`: 29 test su rilevamento lingua, dizionari speculari e segnali di cambio lingua.
6. `tests/test_skill_system.gd`: 29 test sulle 7 abilità musicali e saturazione giornaliera.
7. `tests/test_music_system.gd`: 35 test sulla pipeline di creazione brani e calcolo qualità.
8. `tests/test_concert_system.gd`: 53 test sul motore concerti, affluenza, stage events e closer bonus.
9. `tests/test_economy_system.gd`: 22 test su sussistenza, alloggi, bancarotta e stipendi.
10. `tests/test_career_system.gd`: 18 test sulle promozioni di carriera da Nobody a Superstar.
11. `tests/test_band_system.gd`: 55 test su reclutamento band, 4 personalità, affinità, rispetto e tensione.
12. `tests/test_album_system.gd`: 50 test su formati EP e LP, concept artistici e vendite Day 1.
13. `tests/test_industry_system.gd`: 60 test su contratti Indie vs Major, anticipi, recoupment e 3 tipi di manager.
14. `tests/test_dilemma_system.gd`: 25 test sui bivi etico-narrativi e scelte morali.
15. `tests/test_travel_system.gd`: 64 test sulla rete delle 6 città, affinità di genere e costi di viaggio.
16. `tests/test_tour_system.gd`: 65 test su tournée multi-tappa, 3 classi di veicolo e accumulo Hype.
17. `tests/test_festival_system.gd`: 70 test sui festival estivi, slot orari e meccanica "Rubare la Scena".
18. `tests/test_social_media_system.gd`: 65 test su BandFeed, viralità, shitstorm e social buzz.
19. `tests/test_rival_and_chart_system.gd`: 54 test sulle 10 band rivali, Hit Parade Top 10 e conquista del #1.
20. `tests/test_v5_ui_overhaul.gd`: 44 test sull'architettura HUD a 5 sezioni, Top Bar permanente e Menu Esc.
21. `tests/test_upgrades_system.gd`: 68 test su UpgradesModal, 5 famiglie strumenti con comparatore e hardware studio.
